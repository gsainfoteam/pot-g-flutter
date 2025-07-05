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
}
