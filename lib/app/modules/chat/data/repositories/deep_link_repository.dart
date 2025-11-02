import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

abstract class AppType {
  String get iOS;
  String get android;
}

extension on AppType {
  String get iOSStoreUrl => 'https://apps.apple.com/app/$iOS';
  String get androidStoreUrl =>
      'https://play.google.com/store/apps/details?id=$android';
}

abstract class DeepLinkRepository<App extends AppType, Entity> {
  Future<void> action(App type, Entity entity) async {
    final deepLink = getDeepLink(type, entity);
    if (await launchUrl(deepLink)) return;
    final webUrl = getWebUrl(type, entity);
    if (webUrl != null && await launchUrl(webUrl)) return;
    await launchUrl(getStoreUrl(type));
  }

  Uri getDeepLink(covariant AppType type, covariant Entity entity);
  Uri? getWebUrl(covariant AppType type, covariant Entity entity) => null;
  Uri getStoreUrl(covariant AppType type) {
    if (Platform.isAndroid) return Uri.parse(type.androidStoreUrl);
    return Uri.parse(type.iOSStoreUrl);
  }
}
