import 'package:pot_g/app/modules/socket/data/models/base/base_server_message_model.dart';
import 'package:pot_g/app/modules/socket/data/models/base/base_socket_request_model.dart';

enum SocketConnectionState {
  connected,
  connecting,
  reconnecting,
  disconnected,
  failed,
}

abstract interface class SocketInterface {
  /// if there is a connection, it will be disconnected and then connected.
  /// When [connect] is called simultaneously, the connection will be established only once.
  Future<void> connect();

  /// if there is a connection, it will be disconnected.
  Future<void> disconnect();

  /// send request to server.
  Future<void> sendRequest(BaseSocketRequestEvent request, {String? requestId});

  /// create a stream for a specific event.
  Stream<BaseServerMessageModel<T>>
  createStreamFor<T extends BaseServerMessageEvent>();

  /// get the next message from server.
  /// example:
  /// ```dart
  /// final requestId = Uuid().v4();
  /// await Future.wait([
  ///   socket.getNextMessage<AuthorizationResponseModel>(requestId: requestId),
  ///   socket.sendRequest(AuthorizationModel(authorization: 'token'), requestId: requestId),
  /// ]);
  /// ```
  Future<BaseServerMessageModel<T>> getNextMessage<
    T extends BaseServerMessageEvent
  >({String? requestId, Duration? timeout});

  /// get the connection state.
  /// first value is the current state.
  Stream<SocketConnectionState> get connectionState;
}
