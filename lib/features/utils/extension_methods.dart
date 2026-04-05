extension DateTimeDateSwap on DateTime {
  DateTime withTodayDate() {
    final DateTime now = DateTime.now();

    return DateTime(now.year, now.month, now.day, hour, minute, second);
  }
}
