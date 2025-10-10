import 'dart:developer';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/configuration.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:amplitude_flutter/events/identify.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/common/domain/repositories/log_repository.dart';
import 'package:pot_g/app/values/config.dart';

@Singleton(as: LogRepository)
class AmplitudeLogRepository extends LogRepository {
  late final _instance = Amplitude(
    Configuration(apiKey: Config.amplitudeApiKey),
  );

  @override
  void logEvent(String eventName, Map<String, dynamic> properties) {
    if (kDebugMode) {
      log('$eventName $properties', name: 'amplitude');
    } else {
      _instance.track(BaseEvent(eventName, eventProperties: properties));
    }
  }

  @override
  void setUserId(String? userId) {
    if (kDebugMode) {
      log('setUserId $userId', name: 'amplitude');
    } else {
      _instance.setUserId(userId);
      if (userId == null) {
        final identify = Identify();
        identify.clearAll();
        _instance.identify(identify);
      }
    }
  }

  @override
  void setUserProperty(String key, String? value) {
    if (kDebugMode) {
      log('setUserProperty $key $value', name: 'amplitude');
    } else {
      final identify = Identify();
      if (value != null) {
        identify.set(key, value);
      } else {
        identify.unset(key);
      }
      _instance.identify(identify);
    }
  }
}
