import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/auth/data/data_sources/remote/user_auth_api.dart';
import 'package:pot_g/app/modules/auth/data/models/login_request_model.dart';
import 'package:pot_g/app/modules/auth/data/models/logout_request_model.dart';
import 'package:pot_g/app/modules/auth/domain/exceptions/withdraw_exception.dart';
import 'package:pot_g/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:pot_g/app/modules/auth/domain/repositories/oauth_repository.dart';
import 'package:pot_g/app/modules/auth/domain/repositories/token_repository.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/device/domain/repositories/device_info_repository.dart';
import 'package:pot_g/app/modules/user/domain/entities/self_user_entity.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

@Injectable(as: AuthRepository)
class OauthRestAuthRepository implements AuthRepository {
  final TokenRepository _tokenRepository;
  final OAuthRepository _oAuthRepository;
  final UserAuthApi _userAuthApi;
  final DeviceInfoRepository _deviceInfoRepository;
  final _userSubject = BehaviorSubject<SelfUserEntity?>();

  OauthRestAuthRepository(
    this._tokenRepository,
    this._oAuthRepository,
    this._userAuthApi,
    this._deviceInfoRepository,
  ) {
    _tokenRepository.token
        .asyncMap((token) async {
          if (token == null) return null;
          return await _getUser();
        })
        .shareReplay(maxSize: 1)
        .listen((user) {
          _userSubject.add(user);
        });
  }

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
    try {
      final refreshToken = await _tokenRepository.refreshToken.first;
      // empty string is just for fallback
      await _userAuthApi.logout(
        LogoutRequestModel(refreshToken: refreshToken ?? ''),
      );
    } catch (e, stackTrace) {
      L.e(e, stackTrace);
    }
    await _tokenRepository.deleteToken();
    await _oAuthRepository.setRecentLogout();
  }

  @override
  Stream<SelfUserEntity?> get user async* {
    if (_userSubject.hasValue) {
      yield _userSubject.value;
    }
    yield* _userSubject.stream;
  }

  Future<SelfUserEntity?> _getUser() async {
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
  }

  @override
  Future<void> update() async {
    final user = await _getUser();
    _userSubject.add(user);
  }

  @override
  Future<void> withdraw() async {
    try {
      await _userAuthApi.withdraw();
      await _tokenRepository.deleteToken();
    } on DioException catch (e) {
      throw WithdrawException.networkError(e.message ?? e.error.toString());
    } catch (e) {
      throw WithdrawException.unknown(e);
    }
  }
}
