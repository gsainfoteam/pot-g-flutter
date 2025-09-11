import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/device/domain/repositories/device_info_repository.dart';

@LazySingleton(as: DeviceInfoRepository)
class DeviceInfoPlusDeviceInfoRepository implements DeviceInfoRepository {
  final DeviceInfoPlugin _deviceInfoPlugin;

  DeviceInfoPlusDeviceInfoRepository(this._deviceInfoPlugin);

  @override
  Future<String> getDeviceId() async {
    if (Platform.isAndroid) {
      final deviceInfo = await _deviceInfoPlugin.androidInfo;
      return deviceInfo.id;
    }
    if (Platform.isIOS) {
      for (var i = 0; i < 10; i++) {
        final deviceInfo = await _deviceInfoPlugin.iosInfo;
        if (deviceInfo.identifierForVendor != null) {
          return deviceInfo.identifierForVendor!;
        }
        await Future.delayed(const Duration(seconds: 1));
      }
      // https://developer.apple.com/documentation/uikit/uidevice/identifierforvendor
      // 문서에 따르면 nil인 경우에 다시 시도하라고만 되어있어서
      // 10번 이상 시도했는데 여전히 nil인 경우는 없다고 생각했습니다
      throw Exception('Failed to get device id');
    }
    throw UnimplementedError('Unsupported platform');
  }
}
