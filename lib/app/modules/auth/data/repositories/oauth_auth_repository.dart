import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/auth/domain/entity/user_entity.dart';
import 'package:pot_g/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:pot_g/app/modules/auth/domain/repositories/oauth_repository.dart';
import 'package:pot_g/app/modules/auth/domain/repositories/token_repository.dart';

@Injectable(as: AuthRepository)
class OauthAuthRepository implements AuthRepository {
  final TokenRepository _tokenRepository;
  final OAuthRepository _oAuthRepository;

  OauthAuthRepository(this._tokenRepository, this._oAuthRepository);

  @override
  Stream<bool> get isSignedIn =>
      _tokenRepository.token.map((token) => token != null);

  @override
  Future<UserEntity> signIn() async {
    final token = await _oAuthRepository.getToken();
    await _tokenRepository.saveToken(token.idToken);
    await _tokenRepository.saveRefreshToken(token.refreshToken);
    try {
      return _parseUser(token.idToken);
    } catch (e) {
      await _tokenRepository.deleteToken();
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _tokenRepository.deleteToken();
    await _oAuthRepository.setRecentLogout();
  }

  UserEntity _parseUser(String token) {
    final parts = token.split('.');
    final payload = jsonDecode(
      utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
    );
    return UserEntity(
      email: payload['email'],
      name: payload['name'],
      uuid: payload['sub'],
    );
  }

  @override
  Stream<UserEntity?> get user => _tokenRepository.token.map((token) {
    if (token == null) return null;
    try {
      return _parseUser(token);
    } catch (e) {
      _tokenRepository.deleteToken();
      return null;
    }
  });
}
