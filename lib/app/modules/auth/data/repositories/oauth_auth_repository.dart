import 'package:injectable/injectable.dart';
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
  Future<void> signIn() async {
    final token = await _oAuthRepository.getToken();
    await _tokenRepository.saveToken(token.idToken);
    await _tokenRepository.saveRefreshToken(token.refreshToken);
  }

  @override
  Future<void> signOut() async {
    await _tokenRepository.deleteToken();
    await _oAuthRepository.setRecentLogout();
  }
}
