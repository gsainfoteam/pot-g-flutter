import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/core/domain/repositories/api_channel_repository.dart';
import 'package:pot_g/app/modules/socket/data/models/base/base_server_message_model.dart';
import 'package:pot_g/app/modules/socket/data/models/base/base_socket_request_model.dart';
import 'package:pot_g/app/modules/socket/data/models/converter/client_converter.dart';
import 'package:pot_g/app/modules/socket/data/models/converter/server_converter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum SocketConnectionState {
  connected,
  connecting,
  reconnecting,
  disconnected,
  failed,
}

@lazySingleton
class PotGSocket {
  static const int _maxRetries = 5;
  static const int _maxBackoffSeconds = 30;

  final ApiChannelRepository _apiChannelRepository;
  WebSocketChannel? _channel;
  final _socketEventController =
      StreamController<BaseServerMessageModel>.broadcast();
  final _connectionStateController =
      StreamController<SocketConnectionState>.broadcast();
  StreamSubscription? _channelSubscription;
  bool _shouldConnected = false;
  int _retryCount = 0;
  Timer? _reconnectTimer;

  bool get isConnected => _channel != null && _channel!.closeCode == null;

  Stream<SocketConnectionState> get connectionState =>
      _connectionStateController.stream;

  WebSocketChannel get channel {
    if (!isConnected) {
      throw Exception('WebSocket not connected');
    }
    return _channel!;
  }

  PotGSocket(this._apiChannelRepository);

  /// 이미 연결되어 있으면 기존 연결을 끊고 새로 연결
  Future<void> connect() async {
    if (isConnected) {
      await disconnect();
    }
    _shouldConnected = true;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    _connectionStateController.add(SocketConnectionState.connecting);

    try {
      final channel = WebSocketChannel.connect(_apiChannelRepository.wsUrl);
      _channel = channel;
      await channel.ready;

      _retryCount = 0;
      _connectionStateController.add(SocketConnectionState.connected);

      // 새로운 channel의 stream을 기존 controller에 연결
      _setupChannelSubscription();
    } catch (e) {
      _connectionStateController.add(SocketConnectionState.disconnected);
      if (_shouldConnected) {
        _reconnect();
      }
      rethrow;
    }
  }

  void _setupChannelSubscription() {
    if (_channel == null) return;

    // 기존 subscription이 있으면 취소
    _channelSubscription?.cancel();

    // 새로운 subscription 생성
    _channelSubscription = _channel!.stream.listen(
      (event) {
        try {
          if (kDebugMode) {
            log(event, name: 'websocket');
          }
          final Map<String, dynamic> jsonData = jsonDecode(event);
          final data = convertServerMessage(jsonData);
          _socketEventController.add(data);
        } catch (e) {
          // JSON 파싱 오류 처리
          _socketEventController.addError(e);
        }
      },
      onError: (error) {
        _socketEventController.addError(error);
      },
      onDone: () {
        if (kDebugMode) {
          log('WebSocket connection closed', name: 'websocket');
        }
        _connectionStateController.add(SocketConnectionState.disconnected);
        if (_shouldConnected) {
          _reconnect();
        }
      },
    );
  }

  Future<void> disconnect() async {
    _shouldConnected = false;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _retryCount = 0;

    _channelSubscription?.cancel();
    _channelSubscription = null;

    if (_channel != null) {
      unawaited(
        _channel!.sink.close().catchError((error, stackTrace) {
          L.e(error, stackTrace);
        }),
      );
      _channel = null;
    }

    _connectionStateController.add(SocketConnectionState.disconnected);
  }

  /// 연결 상태를 확인하고 필요시 자동 재연결
  Future<void> _ensureConnected() async {
    if (!_shouldConnected) return;
    if (!isConnected) {
      await connect();
    }
  }

  /// 메인 raw message stream
  Stream<BaseServerMessageModel> get rawMessages {
    _ensureConnected();
    return _socketEventController.stream;
  }

  /// 특정 타입의 이벤트만 필터링하는 stream
  Stream<BaseServerMessageModel<T>>
  createStreamFor<T extends BaseServerMessageEvent>() {
    return rawMessages
        .where((message) => message is BaseServerMessageModel<T>)
        .cast<BaseServerMessageModel<T>>();
  }

  Future<BaseServerMessageModel<T>> getNextMessage<
    T extends BaseServerMessageEvent
  >([Duration? timeout = const Duration(seconds: 30)]) async {
    var future = rawMessages.firstWhere(
      (message) => message is BaseServerMessageModel<T>,
    );
    if (timeout != null) {
      future = future.timeout(
        timeout,
        onTimeout: () => throw TimeoutException(
          'No message received within the specified timeout',
        ),
      );
    }
    final message = await future;
    return message as BaseServerMessageModel<T>;
  }

  /// 지수 백오프 전략으로 재연결 시도
  void _reconnect() {
    if (!_shouldConnected) return;
    if (_retryCount >= _maxRetries) {
      if (kDebugMode) {
        log('Max retry attempts reached', name: 'websocket');
      }
      L.e(Exception('Max retry attempts reached'), StackTrace.current);
      _connectionStateController.add(SocketConnectionState.failed);
      return;
    }

    _retryCount++;
    final backoffSeconds = (1 << (_retryCount - 1)).clamp(
      1,
      _maxBackoffSeconds,
    );

    if (kDebugMode) {
      log(
        'Reconnecting in $backoffSeconds seconds (attempt $_retryCount/$_maxRetries)',
        name: 'websocket',
      );
    }

    _connectionStateController.add(SocketConnectionState.reconnecting);

    _reconnectTimer = Timer(Duration(seconds: backoffSeconds), () {
      connect().catchError((error, stackTrace) {
        if (kDebugMode) {
          log('Reconnection failed: $error', name: 'websocket');
        }
        L.e(error, stackTrace);
      });
    });
  }

  Future<void> sendRequest(
    BaseSocketRequestEvent request, {
    String? requestId,
  }) async {
    await _ensureConnected();
    final data = jsonEncode(convertClientMessage(request, requestId));
    if (kDebugMode) {
      log(data, name: 'websocket');
    }
    channel.sink.add(data);
  }
}
