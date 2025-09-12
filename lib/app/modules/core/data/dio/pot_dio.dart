import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/values/config.dart';

@singleton
class PotDio extends DioForNative {
  PotDio() : super(BaseOptions(baseUrl: Config.apiBaseUrl));
}
