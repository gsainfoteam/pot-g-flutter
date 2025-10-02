import 'package:envied/envied.dart';

part 'config.g.dart';

@Envied(useConstantCase: true)
abstract class Config {
  @EnviedField()
  static const String amplitudeApiKey = _Config.amplitudeApiKey;

  @EnviedField()
  static const String idpClientId = _Config.idpClientId;
  @EnviedField(defaultValue: 'pot-g-idp-login-redirect')
  static const String idpRedirectScheme = _Config.idpRedirectScheme;
  @EnviedField(defaultValue: 'pot-g-idp-login-redirect://callback')
  static const String idpRedirectUri = _Config.idpRedirectUri;
  @EnviedField(defaultValue: 'https://api.idp.gistory.me/')
  static const String idpApiBaseUrl = _Config.idpApiBaseUrl;
  @EnviedField(defaultValue: 'http://api.pot-g.gistory.me:3000/')
  static const String apiBaseUrl = _Config.apiBaseUrl;
  @EnviedField(defaultValue: 'ws://api.pot-g.gistory.me:3000/ws')
  static const String wsUrl = _Config.wsUrl;
}
