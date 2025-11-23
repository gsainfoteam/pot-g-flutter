import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/auth/data/services/token_refresh_service.dart';
import 'package:pot_g/app/modules/auth/domain/repositories/token_repository.dart';
import 'package:pot_g/app/modules/socket/data/data_sources/websocket.dart';
import 'package:pot_g/app/modules/socket/data/models/events/authorization_response_model.dart';
import 'package:pot_g/app/modules/socket/data/models/events/request_authorization_event_model.dart';
import 'package:pot_g/app/modules/socket/data/models/requests/authorization_model.dart';
import 'package:pot_g/app/modules/socket/domain/socket_authorization_repository.dart';

@Singleton(as: SocketAuthorizationRepository)
class WebsocketSocketAuthorizationRepository
    implements SocketAuthorizationRepository {
  final PotGSocket _socket;
  final TokenRepository _tokenRepository;
  final TokenRefreshService _tokenRefreshService;

  WebsocketSocketAuthorizationRepository(
    this._socket,
    this._tokenRepository,
    this._tokenRefreshService,
  );

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    _socket.createStreamFor<RequestAuthorizationEventModel>().listen(
      (event) => authorize(event.requestId),
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

  Future<void> authorize(String requestId, [int retry = 0]) async {
    final expiration = _tokenRepository.tokenExpiration;
    if (expiration != null && expiration.isBefore(DateTime.now())) {
      await _tokenRefreshService.refresh();
    }

    final token = await _tokenRepository.token.first;
    if (token == null) throw Exception('Token is null');
    try {
      await Future.wait([
        _socket.getNextMessage<AuthorizationResponseModel>(
          requestId: requestId,
        ),
        _socket.sendRequest(
          AuthorizationModel(authorization: token),
          requestId: requestId,
        ),
      ]).timeout(const Duration(seconds: 10));
    } on TimeoutException {
      if (retry < 1) {
        if (await _tokenRefreshService.refresh()) {
          return authorize(requestId, retry + 1);
        }
      }
      rethrow;
    }
  }
}
