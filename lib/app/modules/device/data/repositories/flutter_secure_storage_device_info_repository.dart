import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/device/domain/repositories/device_info_repository.dart';
import 'package:uuid/uuid.dart';

@LazySingleton(as: DeviceInfoRepository)
class FlutterSecureStorageDeviceInfoRepository implements DeviceInfoRepository {
  final FlutterSecureStorage _storage;
  static const _key = 'device_id';

  FlutterSecureStorageDeviceInfoRepository(this._storage);

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    final deviceId = await _storage.read(key: _key);
    if (deviceId != null) return;
    final newDeviceId = Uuid().v4();
    await _storage.write(key: _key, value: newDeviceId);
  }

  @override
  Future<String> getDeviceId() async {
    final deviceId = await _storage.read(key: _key);
    if (deviceId == null) {
      throw Exception('Device id not found');
    }
    return deviceId;
  }
}
