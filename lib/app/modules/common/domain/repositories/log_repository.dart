abstract class LogRepository {
  void logEvent(String eventName, Map<String, dynamic> properties);
  void setUserId(String? userId);
  void setUserProperty(String key, String? value);

  void setUserProperties(Map<String, String?> properties) {
    for (final property in properties.entries) {
      setUserProperty(property.key, property.value);
    }
  }
}
