import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pot_g/app/modules/core/data/data_sources/version_api.dart';
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
  Future<bool> updateAvailable() async {
    return await getCurrentVersion() < await getLatestVersion();
  }

  @override
  Future<bool> updateRequired() async {
    return await getCurrentVersion() < await getMinVersion();
  }

  @override
  Future<Version> getLatestVersion() async {
    final response = await _api.getVersion();
    return Version.parse(
      _getOS() == OS.android
          ? response.aosLatestVersion
          : response.iosLatestVersion,
    );
  }

  @override
  Future<Version> getMinVersion() async {
    final response = await _api.getVersion();
    return Version.parse(
      _getOS() == OS.android ? response.aosMinVersion : response.iosMinVersion,
    );
  }
}
