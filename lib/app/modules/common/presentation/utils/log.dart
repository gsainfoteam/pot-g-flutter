import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/common/domain/repositories/log_repository.dart';

class L {
  static String _currentPage = '';

  static void setCurrentPage(String page) {
    _log('pageview_$page', {});
    _currentPage = page;
  }

  static void _log(String eventName, Map<String, dynamic> properties) =>
      sl<LogRepository>().logEvent(eventName, {
        ...properties,
        if (_currentPage.isNotEmpty && !properties.containsKey('from'))
          'from': _currentPage,
      });

  /// Click log
  static void c(
    String eventName, {
    String? from,
    Map<String, dynamic> properties = const {},
  }) => _log('click_$eventName', {
    ...properties,
    if (from?.isNotEmpty ?? false) 'from': from,
  });
  static void v(
    String eventName, {
    String? from,
    Map<String, dynamic> properties = const {},
  }) => _log('view_$eventName', {
    ...properties,
    if (from?.isNotEmpty ?? false) 'from': from,
  });

  static void setUserId(String? userId) =>
      sl<LogRepository>().setUserId(userId);

  static void setUserProperties(Map<String, String?> properties) =>
      sl<LogRepository>().setUserProperties(properties);
}
