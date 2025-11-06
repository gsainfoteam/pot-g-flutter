import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:nonce/nonce.dart';
import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/common/domain/repositories/log_repository.dart';

class L {
  static String _currentPage = '';

  static void setCurrentPage(
    String page, {
    Map<String, Object> properties = const {},
  }) {
    _log('pageview_$page', properties);
    _currentPage = page;
  }

  static void _log(String eventName, Map<String, Object?> properties) =>
      sl<LogRepository>().logEvent(eventName, {
        ...properties,
        if (_currentPage.isNotEmpty && !properties.containsKey('from'))
          'from': _currentPage,
      });

  /// Click log
  static void c(
    String eventName, {
    String? from,
    Map<String, Object?> properties = const {},
  }) => _log('click_$eventName', {
    ...properties,
    if (from?.isNotEmpty ?? false) 'from': from!,
  });
  static void v(
    String eventName, {
    String? from,
    Map<String, Object?> properties = const {},
  }) => _log('view_$eventName', {
    ...properties,
    if (from?.isNotEmpty ?? false) 'from': from!,
  });

  static void setUserId(String? userId) =>
      sl<LogRepository>().setUserId(userId);

  static void setUserProperties(Map<String, String?> properties) =>
      sl<LogRepository>().setUserProperties(properties);

  /// returns a unique identifier for the error
  static String e(Object error, StackTrace stackTrace, {bool fatal = false}) {
    final nonce = Nonce.secure(8).toString();
    if (!kDebugMode) {
      FirebaseCrashlytics.instance
          .recordError(error, stackTrace, information: [nonce], fatal: fatal)
          .ignore();
    } else {
      log(
        error.toString(),
        stackTrace: stackTrace,
        name: 'error',
        level: Level.SEVERE.value,
      );
    }
    return nonce;
  }
}

class LL {
  final Map<String, Object?> _properties;
  LL(this._properties);

  void c(
    String eventName, {
    String? from,
    Map<String, Object?> properties = const {},
  }) {
    L.c(eventName, from: from, properties: {..._properties, ...properties});
  }

  void v(
    String eventName, {
    String? from,
    Map<String, Object?> properties = const {},
  }) {
    L.v(eventName, from: from, properties: {..._properties, ...properties});
  }
}
