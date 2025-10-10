import 'package:pot_g/app/di/locator.dart';
import 'package:pot_g/app/modules/common/domain/repositories/log_repository.dart';

class L {
  /// Click log
  static void c(
    String eventName, {
    Map<String, dynamic> properties = const {},
  }) => sl<LogRepository>().logEvent('click_$eventName', properties);
  static void v(String eventName, Map<String, dynamic> properties) =>
      sl<LogRepository>().logEvent('view_$eventName', properties);
  static void pv(String eventName, Map<String, dynamic> properties) =>
      sl<LogRepository>().logEvent('pageview_$eventName', properties);

  static void setUserId(String userId) => sl<LogRepository>().setUserId(userId);

  static void setUserProperties(Map<String, String?> properties) =>
      sl<LogRepository>().setUserProperties(properties);
}
