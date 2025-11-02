import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

abstract class AppType {
  String get iOSStoreUrl;
  String get androidStoreUrl;
}

abstract class DeepLinkRepository<App extends AppType, Entity> {
  Future<void> action(App type, Entity entity) async {
    final deepLink = getDeepLink(type, entity);
    if (await canLaunchUrl(deepLink)) {
      await launchUrl(deepLink);
    } else {
      final webUrl = getWebUrl(type, entity);
      if (webUrl != null && await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl);
      } else {
        await launchUrl(getStoreUrl(type));
      }
    }
  }

  Uri getDeepLink(covariant AppType type, covariant Entity entity);
  Uri? getWebUrl(covariant AppType type, covariant Entity entity) => null;
  Uri getStoreUrl(covariant AppType type) {
    if (Platform.isAndroid) return Uri.parse(type.androidStoreUrl);
    return Uri.parse(type.iOSStoreUrl);
  }
}
