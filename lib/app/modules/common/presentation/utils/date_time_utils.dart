class DateTimeUtils {
  /// Combines date and time into a single DateTime
  static DateTime combineDateTime(DateTime date, DateTime time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  /// Returns current time with seconds and milliseconds set to 0
  static DateTime getCurrentTime() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, now.hour, now.minute);
  }

  /// Returns current time if date is today, null otherwise
  static DateTime? getMinTimeForDate(DateTime date) {
    return date.isToday ? getCurrentTime() : null;
  }
}

/// DateTime extension for convenient date and time operations
extension DateTimeExtension on DateTime {
  /// Checks if this date is the same day as another date
  bool isSameDayAs(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Combines this date with given time
  DateTime combineWithTime(DateTime time) {
    return DateTime(year, month, day, time.hour, time.minute);
  }

  /// Checks if this date is today
  bool get isToday {
    return isSameDayAs(DateTime.now());
  }

  /// Returns current time if this date is today, null otherwise
  DateTime? get minTimeForDate {
    return isToday ? DateTimeUtils.getCurrentTime() : null;
  }
}
