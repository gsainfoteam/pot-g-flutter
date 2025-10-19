extension DateTimeX on DateTime {
  DateTime startOfMonth() => DateTime(year, month, 1);
  DateTime endOfMonth() => DateTime(year, month + 1, 0);

  /// Sunday is first
  DateTime startOfWeek() => DateTime(year, month, day - weekday);
  DateTime endOfWeek() => DateTime(year, month, day + (7 - weekday));
  DateTime addMonths(int months) => DateTime(year, month + months, day);
  DateTime subtractMonths(int months) => DateTime(year, month - months, day);
  DateTime addDays(int days) => DateTime(year, month, day + days);
  DateTime subtractDays(int days) => DateTime(year, month, day - days);
  DateTime addWeeks(int weeks) => DateTime(year, month, day + weeks * 7);
  DateTime subtractWeeks(int weeks) => DateTime(year, month, day - weeks * 7);
  DateTime addYears(int years) => DateTime(year + years, month, day);
  DateTime subtractYears(int years) => DateTime(year - years, month, day);

  DateTime startOfDay() => DateTime(year, month, day, 0, 0, 0, 0);
  DateTime endOfDay() => DateTime(year, month, day, 23, 59, 59, 999);

  bool isSameMonth(DateTime other) =>
      year == other.year && month == other.month;
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
  bool get isToday => isSameDay(DateTime.now());

  DateTime combineWithTime(DateTime time) {
    return DateTime(year, month, day, time.hour, time.minute);
  }
}
