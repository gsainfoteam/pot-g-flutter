import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/auth/data/data_sources/remote/user_auth_api.dart';
import 'package:pot_g/app/modules/auth/data/models/login_request_model.dart';
import 'package:pot_g/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:pot_g/app/modules/auth/domain/repositories/oauth_repository.dart';
import 'package:pot_g/app/modules/auth/domain/repositories/token_repository.dart';
import 'package:pot_g/app/modules/device/domain/repositories/device_info_repository.dart';
import 'package:pot_g/app/modules/user/domain/entities/self_user_entity.dart';
import 'package:rxdart/streams.dart';

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
  Future<SelfUserEntity> signIn() async {
    final deviceId = await _deviceInfoRepository.getDeviceId();
    final idPToken = await _oAuthRepository.getToken();
    final token = await _userAuthApi.login(
      LoginRequestModel(token: idPToken.accessToken, deviceId: deviceId),
    );
    await _tokenRepository.saveToken(token.accessToken);
    await _tokenRepository.saveRefreshToken(token.refreshToken);
    try {
      return await _userAuthApi.getUser();
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401 || status == 403) {
        await _tokenRepository.deleteToken();
      }
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _tokenRepository.deleteToken();
    await _oAuthRepository.setRecentLogout();
  }

  @override
  Stream<SelfUserEntity?> get user => _tokenRepository.token
      .asyncMap((token) async {
        if (token == null) return null;
        try {
          final user = await _userAuthApi.getUser();
          return user;
        } on DioException catch (e) {
          final status = e.response?.statusCode;
          if (status == 401 || status == 403) {
            await _tokenRepository.deleteToken();
          }
          return null;
        }
      })
      .shareReplay(maxSize: 1);
}
