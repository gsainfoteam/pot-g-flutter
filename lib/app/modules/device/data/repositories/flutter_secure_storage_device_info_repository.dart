import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/device/domain/repositories/device_info_repository.dart';
import 'package:uuid/uuid.dart';

@LazySingleton(as: DeviceInfoRepository)
class FlutterSecureStorageDeviceInfoRepository implements DeviceInfoRepository {
  final FlutterSecureStorage _storage;
  static const _key = 'device_id';

  FlutterSecureStorageDeviceInfoRepository(this._storage);

  @override
  Future<String> getDeviceId() async {
    final deviceId = await _storage.read(key: _key);
    if (deviceId != null) return deviceId;
    final newDeviceId = Uuid().v4();
    await _storage.write(key: _key, value: newDeviceId);
    return newDeviceId;
  }
}
