import 'package:pot_g/app/modules/core/domain/enums/os.dart';

abstract class AppVersionRepository {
  Future<String> getCurrentVersion();
  Future<OS> getPlatform();
  Future<bool> updateRequired();
  Future<String> getLatestVersion();
  Future<String> getMinVersion();
}
