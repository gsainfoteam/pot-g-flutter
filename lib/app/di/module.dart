import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@module
abstract class Module {
  FlutterSecureStorage get flutterSecureStorage => const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Dio get dio => Dio(BaseOptions(baseUrl: 'http://api.pot-g.gistory.me:3000/'));

  DeviceInfoPlugin get deviceInfoPlugin => DeviceInfoPlugin();
}
