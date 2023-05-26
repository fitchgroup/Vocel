int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

/// Create a process to purge calendar items before and after 3 months
final utilToday = DateTime.now();
final utilFirstDay = DateTime(utilToday.year, utilToday.month - 3, utilToday.day); // display the last three months
final utilLateDay = DateTime(utilToday.year, utilToday.month + 3, utilToday.day); // display the future three months
