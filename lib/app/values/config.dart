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
  @EnviedField(defaultValue: 'market://details?id=me.gistory.pot_g')
  static const String playStoreUrl = _Config.playStoreUrl;
  @EnviedField(defaultValue: 'https://apps.apple.com/app/id6744280856')
  static const String appStoreUrl = _Config.appStoreUrl;
}
