import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/auth/data/data_sources/remote/user_auth_api.dart';
import 'package:pot_g/app/modules/auth/data/models/refresh_request_model.dart';
import 'package:pot_g/app/modules/auth/domain/repositories/token_repository.dart';
import 'package:pot_g/app/modules/core/data/dio/pot_dio.dart';
import 'package:retrofit/retrofit.dart';

class PreventRetry extends Extra {
  static const _data = {AuthorizeInterceptor._retriedKey: true};
  const PreventRetry() : super(_data);
}

@injectable
class AuthorizeInterceptor extends Interceptor {
  final TokenRepository repository;
  static const _retriedKey = '_retried';
  final mutex = ReadWriteMutex();

  AuthorizeInterceptor(this.repository);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.retried) return handler.next(options);

    try {
      await mutex.acquireRead();
      final token = await repository.token.first;
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    } finally {
      mutex.release();
    }
  }

  Dio getDio() => sl<PotDio>();
  UserAuthApi get _authApi => sl<UserAuthApi>();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final dio = getDio();
    final statusCode = err.response?.statusCode;
    if (statusCode != 401) return handler.next(err);
    final token = await repository.token.first;
    if (token == null) return handler.next(err);
    if (err.requestOptions.retried) return handler.next(err);
    err.requestOptions.retried = true;

    try {
      if (!(await refresh())) return handler.next(err);
      final retriedResponse = await dio.fetch(err.requestOptions);
      return handler.resolve(retriedResponse);
    } on DioException {
      return super.onError(err, handler);
    }
  }

  Future<bool> refresh() async {
    if (mutex.isWriteLocked) {
      await mutex.acquireRead();
      mutex.release();
      final token = await repository.token.first;
      return token != null;
    }
    await mutex.acquireWrite();
    try {
      final token = await repository.refreshToken.first;
      if (token == null) return false;
      final res = await _authApi.refresh(
        RefreshRequestModel(refreshToken: token),
      );
      await repository.saveToken(res.accessToken);
      return true;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401 || status == 403) {
        await repository.deleteToken();
      }
      return false;
    } finally {
      mutex.release();
    }
  }
}

extension _RequestOptionsX on RequestOptions {
  bool get retried => extra.containsKey(AuthorizeInterceptor._retriedKey);
  set retried(bool value) => extra[AuthorizeInterceptor._retriedKey] = value;
}
