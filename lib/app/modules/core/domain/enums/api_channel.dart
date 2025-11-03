import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum ApiChannel {
  dev(
    'https://api.dev.pot-g.gistory.me/',
    'wss://api.dev.pot-g.gistory.me/ws',
    'https://dev.pot-g.gistory.me/',
    Colors.orange,
  ),
  qa(
    'https://api.qa.pot-g.gistory.me/',
    'wss://api.qa.pot-g.gistory.me/ws',
    'https://qa.pot-g.gistory.me/',
    Colors.blue,
  ),
  prod(
    'https://api.pot-g.gistory.me/',
    'wss://api.pot-g.gistory.me/ws',
    'https://pot-g.gistory.me/',
    Colors.green,
  );

  final String url;
  final String appLinkUrl;
  final String _wsUrl;
  final Color color;
  Uri get wsUrl => Uri.parse(_wsUrl);
  const ApiChannel(this.url, this._wsUrl, this.appLinkUrl, this.color);
  factory ApiChannel.byMode() => kDebugMode ? dev : prod;
}
