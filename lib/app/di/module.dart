import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/core/data/repositories/fcm_messaging_repository.dart';
import 'package:pot_g/app/modules/core/domain/repositories/messaging_repository.dart';
import 'package:pot_g/app/router.dart';

@module
abstract class Module {
  FlutterSecureStorage get flutterSecureStorage => const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  DeviceInfoPlugin get deviceInfoPlugin => DeviceInfoPlugin();

  MessagingRepository getMessagingRepository(FcmMessagingRepository repo) =>
      repo;

  AppRouter get appRouter => AppRouter();
}
