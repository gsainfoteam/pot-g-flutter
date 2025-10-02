import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/socket/data/models/base_socket_request_model.dart';
import 'package:pot_g/app/modules/socket/data/models/base_socket_response_model.dart';
import 'package:pot_g/app/values/config.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

@lazySingleton
class PotGSocket {
  final _wsUrl = Uri.parse(Config.wsUrl);
  WebSocketChannel? _channel;
  StreamController<BaseSocketResponseModel>? _responseController;
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
          final response = BaseSocketResponseModel.fromJson(event);
          _responseController?.add(response);
        } catch (e) {
          // JSON 파싱 오류 처리
          _responseController?.addError(e);
        }
      },
      onError: (error) {
        _responseController?.addError(error);
      },
      onDone: () {
        _responseController?.close();
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

    _responseController?.close();
    _responseController = null;
  }

  /// 연결 상태를 확인하고 필요시 자동 재연결
  Future<void> _ensureConnected() async {
    if (!isConnected) {
      await connect();
    }
  }

  Stream<BaseSocketResponseModel> get onResponse {
    // Controller가 없거나 닫혀있으면 새로 생성
    if (_responseController == null || _responseController!.isClosed) {
      _responseController =
          StreamController<BaseSocketResponseModel>.broadcast();
    }

    _ensureConnected();
    return _responseController!.stream;
  }

  Future<void> sendRequest(BaseSocketRequestModel request) async {
    await _ensureConnected();
    channel.sink.add(request.toJson());
  }
}
