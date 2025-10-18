import 'package:flutter/foundation.dart';

enum ApiChannel {
  dev(
    'https://api.dev.pot-g.gistory.me/',
    'wss://api.dev.pot-g.gistory.me/ws',
    'https://dev.pot-g.gistory.me/',
  ),
  qa(
    'https://api.qa.pot-g.gistory.me/',
    'wss://api.qa.pot-g.gistory.me/ws',
    'https://qa.pot-g.gistory.me/',
  ),
  prod(
    'https://api.pot-g.gistory.me/',
    'wss://api.pot-g.gistory.me/ws',
    'https://pot-g.gistory.me/',
  );

  final String url;
  final String appLinkUrl;
  final String _wsUrl;
  Uri get wsUrl => Uri.parse(_wsUrl);
  const ApiChannel(this.url, this._wsUrl, this.appLinkUrl);
  factory ApiChannel.byMode() => kDebugMode ? dev : prod;
}
