import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pot_g/app/modules/core/data/data_sources/version_api.dart';
import 'package:pot_g/app/modules/core/domain/enums/os.dart';
import 'package:pot_g/app/modules/core/domain/repositories/app_version_repository.dart';

@Injectable(as: AppVersionRepository)
class RestAppVersionRepository implements AppVersionRepository {
  final VersionApi _api;

  RestAppVersionRepository(this._api);

  @override
  Future<String> getCurrentVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  @override
  Future<OS> getPlatform() async {
    return Platform.isAndroid ? OS.android : OS.ios;
  }

  @override
  Future<bool> updateRequired() async {
    final response = await _api.getVersion();
    print(response);
    return false;
  }

  @override
  Future<String> getLatestVersion() {
    // TODO: implement getLatestVersion
    throw UnimplementedError();
  }

  @override
  Future<String> getMinVersion() {
    // TODO: implement getMinVersion
    throw UnimplementedError();
  }
}
