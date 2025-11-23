import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/auth/data/services/token_refresh_service.dart';
import 'package:pot_g/app/modules/auth/domain/repositories/token_repository.dart';
import 'package:pot_g/app/modules/core/data/dio/pot_dio.dart';
import 'package:retrofit/retrofit.dart';

class SkipAuthorize extends Extra {
  static const _data = {AuthorizeInterceptor._skipKey: true};
  const SkipAuthorize() : super(_data);
}

@injectable
class AuthorizeInterceptor extends Interceptor {
  final TokenRepository repository;
  static const _authorizeRetriedKey = '_authorizeRetried';
  static const _retriesKey = '_retries';
  static const _skipKey = '_skip';

  AuthorizeInterceptor(this.repository);

  TokenRefreshService get _tokenRefreshService => sl<TokenRefreshService>();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.skip) return handler.next(options);
    try {
      await _tokenRefreshService.mutex.acquireRead();
      final token = await repository.token.first;
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    } finally {
      _tokenRefreshService.mutex.release();
    }
  }

  Dio getDio() => sl<PotDio>();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final dio = getDio();
    final statusCode = err.response?.statusCode;
    if (statusCode == 502) {
      if (err.requestOptions.retries >= 4) return handler.next(err);
      await Future.delayed(
        Duration(seconds: (1 << err.requestOptions.retries).clamp(1, 30)),
      );
      err.requestOptions.retries++;
      final retriedResponse = await dio.fetch(err.requestOptions);
      return handler.resolve(retriedResponse);
    }
    if (err.requestOptions.skip) return handler.next(err);
    if (statusCode != 401) return handler.next(err);
    final token = await repository.token.first;
    if (token == null) return handler.next(err);
    if (err.requestOptions.authorizeRetried) return handler.next(err);
    err.requestOptions.authorizeRetried = true;

    try {
      if (!(await _tokenRefreshService.refresh())) return handler.next(err);
      final retriedResponse = await dio.fetch(err.requestOptions);
      return handler.resolve(retriedResponse);
    } on DioException {
      return super.onError(err, handler);
    }
  }
}

extension _RequestOptionsX on RequestOptions {
  int get retries => extra.containsKey(AuthorizeInterceptor._retriesKey)
      ? extra[AuthorizeInterceptor._retriesKey] as int
      : 0;
  set retries(int value) => extra[AuthorizeInterceptor._retriesKey] = value;

  bool get authorizeRetried =>
      extra.containsKey(AuthorizeInterceptor._authorizeRetriedKey)
      ? extra[AuthorizeInterceptor._authorizeRetriedKey] as bool
      : false;
  set authorizeRetried(bool value) =>
      extra[AuthorizeInterceptor._authorizeRetriedKey] = value;

  bool get skip => extra.containsKey(AuthorizeInterceptor._skipKey);
}
