import 'dart:developer';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/configuration.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:amplitude_flutter/events/identify.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pot_g/app/modules/common/domain/repositories/log_repository.dart';
import 'package:pot_g/app/values/config.dart';

@Singleton(as: LogRepository)
class AmplitudeLogRepository extends LogRepository {
  late final _instance = Amplitude(
    Configuration(apiKey: Config.amplitudeApiKey),
  );
  late final _firebaseAnalytics = FirebaseAnalytics.instance;

  @override
  void logEvent(String eventName, Map<String, Object?> properties) {
    if (kDebugMode) {
      log('$eventName $properties', name: 'amplitude');
    } else {
      _instance.track(BaseEvent(eventName, eventProperties: properties));
      final filteredProperties = Map.fromEntries(
        properties.entries.where((e) => e.value != null),
      ).cast<String, Object>();
      if (eventName.startsWith('pageview_')) {
        _firebaseAnalytics.logScreenView(
          screenName: eventName.substring(9),
          parameters: filteredProperties,
        );
      } else {
        _firebaseAnalytics.logEvent(
          name: eventName,
          parameters: filteredProperties,
        );
      }
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
      _firebaseAnalytics.setUserId(id: userId);
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
      _firebaseAnalytics.setUserProperty(name: key, value: value);
    }
  }
}
