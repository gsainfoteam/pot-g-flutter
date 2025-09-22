import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/auth/data/data_sources/remote/authorize_interceptor.dart';
import 'package:pot_g/app/values/config.dart';

@singleton
class PotDio extends DioForNative {
  PotDio(AuthorizeInterceptor interceptor)
    : super(BaseOptions(baseUrl: Config.apiBaseUrl)) {
    interceptors.add(interceptor);
  }
}
