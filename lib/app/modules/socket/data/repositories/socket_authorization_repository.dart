import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/auth/domain/repositories/token_repository.dart';
import 'package:pot_g/app/modules/socket/data/data_sources/websocket.dart';
import 'package:pot_g/app/modules/socket/data/models/events/request_authorization_event_model.dart';
import 'package:pot_g/app/modules/socket/data/models/requests/authorization_model.dart';

@lazySingleton
class SocketAuthorizationRepository {
  final PotGSocket _socket;
  final TokenRepository _tokenRepository;

  SocketAuthorizationRepository(this._socket, this._tokenRepository);

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    _socket.createStreamFor<RequestAuthorizationEventModel>().listen(
      (event) => authorize(),
    );
  }

  Future<void> authorize() async {
    final token = await _tokenRepository.token.first;
    if (token == null) throw Exception('Token is null');
    await _socket.sendRequest(AuthorizationModel(token: token));
    await _socket.getNextMessage<RequestAuthorizationEventModel>();
  }
}
