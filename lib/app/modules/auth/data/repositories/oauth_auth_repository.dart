import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/auth/data/utils/token_helper.dart';
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
  Stream<bool> get isSignedIn => user.map((user) => user != null);

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
    final payload = TokenHelper.getPayload(token);
    try {
      return UserEntity(
        email: payload['email'],
        name: payload['name'],
        uuid: payload['sub'],
      );
    } catch (e) {
      throw FormatException('Failed to parse user from token: $e');
    }
  }

  @override
  Stream<UserEntity?> get user =>
      _tokenRepository.token.asyncMap((token) async {
        if (token == null) return null;
        final exp = _tokenRepository.tokenExpiration;
        if (exp != null && exp.isBefore(DateTime.now())) {
          await _tokenRepository.deleteToken();
          return null;
        }
        try {
          return _parseUser(token);
        } catch (e) {
          await _tokenRepository.deleteToken();
          return null;
        }
      });
}
