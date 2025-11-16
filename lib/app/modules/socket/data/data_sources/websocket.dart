import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/core/domain/repositories/api_channel_repository.dart';
import 'package:pot_g/app/modules/socket/data/data_sources/socket_interface.dart';
import 'package:pot_g/app/modules/socket/data/models/base/base_server_message_model.dart';
import 'package:pot_g/app/modules/socket/data/models/base/base_socket_request_model.dart';
import 'package:pot_g/app/modules/socket/data/models/converter/client_converter.dart';
import 'package:pot_g/app/modules/socket/data/models/converter/server_converter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const int _maxRetries = 5;
const int _maxBackoffSeconds = 30;

Duration getBackOffDuration(int retry) {
  final seconds = (1 << (retry - 1)).clamp(1, _maxBackoffSeconds);
  return Duration(seconds: seconds);
}

@lazySingleton
class PotGSocket implements SocketInterface {
  // ================ state ================
  final _state = BehaviorSubject.seeded(SocketConnectionState.disconnected);

  @override
  Stream<SocketConnectionState> get connectionState => _state.stream;
  bool get isConnected => _state.value == SocketConnectionState.connected;

  // ================ stream ================
  final _messages = StreamController<BaseServerMessageModel>.broadcast();
  StreamSubscription? _serverSubscription;

  @override
  Stream<BaseServerMessageModel<T>>
  createStreamFor<T extends BaseServerMessageEvent>() {
    _ensureConnected();
    return _messages.stream
        .where((e) => e is BaseServerMessageModel<T>)
        .cast<BaseServerMessageModel<T>>();
  }

  @override
  Future<BaseServerMessageModel<T>>
  getNextMessage<T extends BaseServerMessageEvent>({
    String? requestId,
    Duration? timeout = const Duration(seconds: 30),
  }) async {
    await _ensureConnected();
    var future = _messages.stream.firstWhere(
      (message) =>
          message is BaseServerMessageModel<T> &&
          (requestId == null || message.requestId == requestId),
    );
    if (timeout != null) {
      future = future.timeout(
        timeout,
        onTimeout: () => throw TimeoutException(
          'No message received within the specified timeout: $timeout',
        ),
      );
    }
    final message = await future;
    return message as BaseServerMessageModel<T>;
  }

  // ================ channel ================
  WebSocketChannel? _channel;
  final ApiChannelRepository _apiChannelRepository;
  int _retryCount = 0;
  bool _shouldConnected = false;
  Timer? _reconnectTimer;
  final _connectMutex = Mutex();

  PotGSocket(this._apiChannelRepository);

  @override
  /// Thread safe connect.
  /// When [connect] is called simultaneously, [_tryConnect] will be called only once.
  Future<void> connect() async {
    if (!_connectMutex.isLocked) {
      _serverSubscription?.cancel();
      _serverSubscription = null;
      _channel?.sink.close();
      _channel = null;
      _state.add(SocketConnectionState.disconnected);
    }
    await _connectMutex.protect(() async {
      if (isConnected) return;
      await _tryConnect();
    });
  }

  /// Non-thread safe connect.
  Future<void> _tryConnect() async {
    _state.add(SocketConnectionState.connecting);
    try {
      _shouldConnected = true;
      _serverSubscription?.cancel();
      _reconnectTimer?.cancel();
      _channel = WebSocketChannel.connect(_apiChannelRepository.wsUrl);
      await _channel!.ready;
      _retryCount = 0;
      _serverSubscription = _channel!.stream.listen(
        (event) {
          try {
            if (kDebugMode) log('> $event', name: 'socket');
            final Map<String, dynamic> jsonData = jsonDecode(event);
            final data = convertServerMessage(jsonData);
            _messages.add(data);
            // TODO: handle ACK
          } catch (e, stackTrace) {
            L.e(e, stackTrace);
          }
        },
        onError: (error, stackTrace) {
          L.e(error, stackTrace);
        },
        onDone: () {
          _state.add(SocketConnectionState.disconnected);
          if (_shouldConnected) {
            _reconnect().catchError((e, stackTrace) {
              L.e(e, stackTrace);
            });
          }
        },
      );
      _state.add(SocketConnectionState.connected);
    } catch (e, stackTrace) {
      L.e(e, stackTrace);
      _state.add(SocketConnectionState.failed);
      await _reconnect();
    }
  }

  /// After call this function, [_channel] is not null and connected.
  Future<void> _ensureConnected() async {
    if (isConnected) return;
    await connect();
  }

  @override
  Future<void> disconnect() async {
    _shouldConnected = false;
    _serverSubscription?.cancel();
    _serverSubscription = null;
    _channel?.sink.close();
    _channel = null;
  }

  Future<void> _reconnect() async {
    if (++_retryCount > _maxRetries) {
      _state.add(SocketConnectionState.failed);
      throw Exception('Max retries reached');
    }
    _state.add(SocketConnectionState.reconnecting);
    final duration = getBackOffDuration(_retryCount);
    final completer = Completer<void>();
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(duration, () async {
      if (_shouldConnected) {
        await _tryConnect();
      }
      completer.complete();
    });
    await completer.future;
  }

  // ================ request ================

  @override
  Future<void> sendRequest(
    BaseSocketRequestEvent request, {
    String? requestId,
  }) async {
    await _ensureConnected();
    final data = jsonEncode(convertClientMessage(request, requestId));
    if (kDebugMode) log('< $data', name: 'socket');
    _channel!.sink.add(data);
  }
}
