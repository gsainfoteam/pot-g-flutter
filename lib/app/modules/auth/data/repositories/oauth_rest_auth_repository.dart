import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/auth/data/data_sources/remote/user_auth_api.dart';
import 'package:pot_g/app/modules/auth/data/models/login_request_model.dart';
import 'package:pot_g/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:pot_g/app/modules/auth/domain/repositories/oauth_repository.dart';
import 'package:pot_g/app/modules/auth/domain/repositories/token_repository.dart';
import 'package:pot_g/app/modules/device/domain/repositories/device_info_repository.dart';
import 'package:pot_g/app/modules/user/domain/entities/user_entity.dart';

@Injectable(as: AuthRepository)
class OauthRestAuthRepository implements AuthRepository {
  final TokenRepository _tokenRepository;
  final OAuthRepository _oAuthRepository;
  final UserAuthApi _userAuthApi;
  final DeviceInfoRepository _deviceInfoRepository;

  OauthRestAuthRepository(
    this._tokenRepository,
    this._oAuthRepository,
    this._userAuthApi,
    this._deviceInfoRepository,
  );

  @override
  Stream<bool> get isSignedIn => user.map((user) => user != null);

  @override
  Future<UserEntity> signIn() async {
    final deviceId = await _deviceInfoRepository.getDeviceId();
    final idPToken = await _oAuthRepository.getToken();
    final token = await _userAuthApi.login(
      LoginRequestModel(token: idPToken.accessToken, deviceId: deviceId),
    );
    await _tokenRepository.saveToken(token.accessToken);
    await _tokenRepository.saveRefreshToken(token.refreshToken);
    try {
      return _userAuthApi.getUser();
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

  @override
  Stream<UserEntity?> get user =>
      _tokenRepository.token.asyncMap((token) async {
        if (token == null) return null;
        try {
          return _userAuthApi.getUser();
        } catch (e) {
          await _tokenRepository.deleteToken();
          return null;
        }
      });
}
