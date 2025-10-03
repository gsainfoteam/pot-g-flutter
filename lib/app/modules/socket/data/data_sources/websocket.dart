import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/socket/data/models/base_socket_request_model.dart';
import 'package:pot_g/app/modules/socket/data/models/base_socket_response_model.dart';
import 'package:pot_g/app/modules/socket/data/models/request_authorization_event_model.dart';
import 'package:pot_g/app/values/config.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

@lazySingleton
class PotGSocket {
  final _wsUrl = Uri.parse(Config.wsUrl);
  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>>? _rawMessageController;
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
          final Map<String, dynamic> jsonData = event;
          _rawMessageController?.add(jsonData);
        } catch (e) {
          // JSON 파싱 오류 처리
          _rawMessageController?.addError(e);
        }
      },
      onError: (error) {
        _rawMessageController?.addError(error);
      },
      onDone: () {
        _rawMessageController?.close();
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

    _rawMessageController?.close();
    _rawMessageController = null;
  }

  /// 연결 상태를 확인하고 필요시 자동 재연결
  Future<void> _ensureConnected() async {
    if (!isConnected) {
      await connect();
    }
  }

  /// 메인 raw message stream
  Stream<Map<String, dynamic>> get rawMessages {
    if (_rawMessageController == null || _rawMessageController!.isClosed) {
      _rawMessageController =
          StreamController<Map<String, dynamic>>.broadcast();
    }

    _ensureConnected();
    return _rawMessageController!.stream;
  }

  final Map<Type, (String, Function(Map<String, dynamic>))> _mapper = {
    RequestAuthorizationEventModel: (
      'request_authorization',
      RequestAuthorizationEventModel.fromJson,
    ),
  };

  /// 특정 타입의 이벤트만 필터링하는 stream
  Stream<T?> createNullableStreamFor<T extends BaseSocketEventModel>() {
    final (type, fromJson) = _mapper[T]!;
    return rawMessages
        .where((message) => message['type'] == type)
        .map((message) {
          try {
            return BaseSocketResponseModel<T>.fromJson(
              message,
              (json) => fromJson(json as Map<String, dynamic>),
            );
          } catch (e) {
            throw Exception('Failed to parse $type: $e');
          }
        })
        .map((response) => response.body.result);
  }

  Future<void> sendRequest(BaseSocketRequestModel request) async {
    await _ensureConnected();
    channel.sink.add(request.toJson());
  }
}
