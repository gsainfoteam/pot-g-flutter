import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pot_g/app/modules/core/data/data_sources/version_api.dart';
import 'package:pot_g/app/modules/core/data/models/version_response_model.dart';
import 'package:pot_g/app/modules/core/domain/entities/version_info_entity.dart';
import 'package:pot_g/app/modules/core/domain/enums/os.dart';
import 'package:pot_g/app/modules/core/domain/repositories/app_version_repository.dart';
import 'package:pub_semver/pub_semver.dart';

@Injectable(as: AppVersionRepository)
class RestAppVersionRepository implements AppVersionRepository {
  final VersionApi _api;

  RestAppVersionRepository(this._api);

  @override
  Future<Version> getCurrentVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return Version.parse(packageInfo.version);
  }

  OS _getOS() {
    if (Platform.isAndroid) {
      return OS.android;
    } else if (Platform.isIOS) {
      return OS.ios;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  @override
  Future<OS> getPlatform() async {
    return _getOS();
  }

  @override
  Future<VersionInfoEntity> getVersionInfo() async {
    final currentVersion = await getCurrentVersion();
    final response = await _api.getVersion();
    final os = _getOS();
    final latestVersion = response.latestVersion(os);
    final minVersion = response.minVersion(os);
    return VersionInfoEntity(
      currentVersion: currentVersion.toString(),
      latestVersion: latestVersion.toString(),
      minVersion: minVersion.toString(),
      updateAvailable: currentVersion < latestVersion,
      updateRequired: currentVersion < minVersion,
    );
  }
}

extension on VersionResponseModel {
  Version latestVersion(OS os) {
    return switch (os) {
      OS.android => Version.parse(aosLatestVersion),
      OS.ios => Version.parse(iosLatestVersion),
    };
  }

  Version minVersion(OS os) {
    return switch (os) {
      OS.android => Version.parse(aosMinVersion),
      OS.ios => Version.parse(iosMinVersion),
    };
  }
}
