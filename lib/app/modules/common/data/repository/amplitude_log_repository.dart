import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/configuration.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:pot_g/app/values/config.dart';

class AmplitudeLogRepository {
  late final _instance = Amplitude(
    Configuration(apiKey: Config.amplitudeApiKey),
  );

  void logEvent(String eventName, Map<String, dynamic> properties) {
    _instance.track(BaseEvent(eventName, eventProperties: properties));
  }
}
