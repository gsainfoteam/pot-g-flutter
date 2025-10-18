import 'package:flutter/foundation.dart';

enum ApiChannel {
  dev('https://api.dev.pot-g.gistory.me/', 'wss://api.dev.pot-g.gistory.me/ws'),
  qa('https://api.qa.pot-g.gistory.me/', 'wss://api.qa.pot-g.gistory.me/ws'),
  prod('https://api.pot-g.gistory.me/', 'wss://api.pot-g.gistory.me/ws');

  final String url;
  final String _wsUrl;
  Uri get wsUrl => Uri.parse(_wsUrl);
  const ApiChannel(this.url, this._wsUrl);
  factory ApiChannel.byMode() => kDebugMode ? dev : prod;
}
