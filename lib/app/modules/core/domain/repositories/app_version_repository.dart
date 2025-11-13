import 'package:pot_g/app/modules/core/domain/entities/version_info_entity.dart';
import 'package:pot_g/app/modules/core/domain/enums/os.dart';
import 'package:pub_semver/pub_semver.dart';

abstract interface class AppVersionRepository {
  Future<Version> getCurrentVersion();
  Future<OS> getPlatform();
  Future<VersionInfoEntity> getVersionInfo();
}
