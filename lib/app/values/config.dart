import 'package:envied/envied.dart';

part 'config.g.dart';

@Envied(useConstantCase: true)
abstract class Config {
  @EnviedField()
  static const String amplitudeApiKey = _Config.amplitudeApiKey;
}
