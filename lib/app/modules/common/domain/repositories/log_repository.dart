abstract interface class LogRepository {
  void logEvent(String eventName, Map<String, Object?> properties);
  void setUserId(String? userId);
  void setUserProperty(String key, String? value);
}

extension LogRepositoryExtension on LogRepository {
  void setUserProperties(Map<String, String?> properties) {
    for (final property in properties.entries) {
      setUserProperty(property.key, property.value);
    }
  }
}
