import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';
import 'package:pot_g/app/modules/auth/domain/repositories/token_repository.dart';
import 'package:pot_g/app/modules/socket/data/data_sources/websocket.dart';
import 'package:pot_g/app/modules/socket/data/models/events/request_authorization_event_model.dart';
import 'package:pot_g/app/modules/socket/data/models/requests/authorization_model.dart';
import 'package:pot_g/app/modules/socket/domain/socket_authorization_repository.dart';

@LazySingleton(as: SocketAuthorizationRepository)
class WebsocketSocketAuthorizationRepository
    implements SocketAuthorizationRepository {
  final PotGSocket _socket;
  final TokenRepository _tokenRepository;
  final _mutex = Mutex();

  WebsocketSocketAuthorizationRepository(this._socket, this._tokenRepository);

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    _socket.createStreamFor<RequestAuthorizationEventModel>().listen(
      (event) => authorize(),
    );
  }

  @override
  Future<void> connect() async {
    await _socket.connect();
  }

  @override
  Future<void> disconnect() async {
    await _socket.disconnect();
  }

  @override
  Future<void> authorize() async {
    if (_mutex.isLocked) return;
    final token = await _tokenRepository.token.first;
    if (token == null) throw Exception('Token is null');
    await _mutex.acquire();
    await _socket.sendRequest(AuthorizationModel(authorization: token));
    await _socket.getNextMessage<RequestAuthorizationEventModel>();
    _mutex.release();
  }
}
