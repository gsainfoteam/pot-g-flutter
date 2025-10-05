import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/socket/data/models/base/base_server_message_model.dart';
import 'package:pot_g/app/modules/socket/data/models/base/base_socket_request_model.dart';
import 'package:pot_g/app/modules/socket/data/models/converter/client_converter.dart';
import 'package:pot_g/app/modules/socket/data/models/converter/server_converter.dart';
import 'package:pot_g/app/values/config.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

@lazySingleton
class PotGSocket {
  final _wsUrl = Uri.parse(Config.wsUrl);
  WebSocketChannel? _channel;
  StreamController<BaseServerMessageModel>? _socketEventController;
  StreamSubscription? _channelSubscription;

  bool get isConnected => _channel != null && _channel!.closeCode == null;

  WebSocketChannel get channel {
    if (!isConnected) {
      throw Exception('WebSocket not connected');
    }
    return _channel!;
  }

  /// 이미 연결되어 있으면 기존 연결을 끊고 새로 연결
  Future<void> connect() async {
    if (isConnected) {
      await disconnect();
    }

    final channel = WebSocketChannel.connect(_wsUrl);
    _channel = channel;
    await channel.ready;

    // 새로운 channel의 stream을 기존 controller에 연결
    _setupChannelSubscription();
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
          _socketEventController?.add(data);
        } catch (e) {
          // JSON 파싱 오류 처리
          _socketEventController?.addError(e);
        }
      },
      onError: (error) {
        _socketEventController?.addError(error);
      },
      onDone: () {
        _socketEventController?.close();
      },
    );
  }

  Future<void> disconnect() async {
    _channelSubscription?.cancel();
    _channelSubscription = null;

    if (_channel != null) {
      await _channel!.sink.close();
      _channel = null;
    }

    _socketEventController?.close();
    _socketEventController = null;
  }

  /// 연결 상태를 확인하고 필요시 자동 재연결
  Future<void> _ensureConnected() async {
    if (!isConnected) {
      await connect();
    }
  }

  /// 메인 raw message stream
  Stream<BaseServerMessageModel> get rawMessages {
    if (_socketEventController == null || _socketEventController!.isClosed) {
      _socketEventController =
          StreamController<BaseServerMessageModel>.broadcast();
    }
    _ensureConnected();
    return _socketEventController!.stream;
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
        onTimeout:
            () =>
                throw TimeoutException(
                  'No message received within the specified timeout',
                ),
      );
    }
    final message = await future;
    return message as BaseServerMessageModel<T>;
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
