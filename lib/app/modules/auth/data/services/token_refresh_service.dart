import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';
import 'package:pot_g/app/modules/auth/data/data_sources/remote/user_auth_api.dart';
import 'package:pot_g/app/modules/auth/data/models/refresh_request_model.dart';
import 'package:pot_g/app/modules/auth/domain/repositories/token_repository.dart';

@singleton
class TokenRefreshService {
  final TokenRepository _repository;
  final UserAuthApi _authApi;
  final mutex = ReadWriteMutex();

  TokenRefreshService(this._repository, this._authApi);

  Future<bool> refresh() async {
    if (mutex.isWriteLocked) {
      await mutex.acquireRead();
      mutex.release();
      final token = await _repository.token.first;
      return token != null;
    }
    await mutex.acquireWrite();
    try {
      final token = await _repository.refreshToken.first;
      if (token == null) return false;
      final res = await _authApi.refresh(
        RefreshRequestModel(refreshToken: token),
      );
      await _repository.saveToken(res.accessToken);
      return true;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401 || status == 403) {
        await _repository.deleteToken();
      }
      return false;
    } finally {
      mutex.release();
    }
  }
}
