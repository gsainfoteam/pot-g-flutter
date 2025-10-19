import 'package:pot_g/app/modules/core/domain/enums/os.dart';
import 'package:pub_semver/pub_semver.dart';

abstract class AppVersionRepository {
  Future<Version> getCurrentVersion();
  Future<OS> getPlatform();
  Future<bool> updateAvailable();
  Future<bool> updateRequired();
  Future<Version> getLatestVersion();
  Future<Version> getMinVersion();
}
