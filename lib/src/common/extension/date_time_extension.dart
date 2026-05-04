import 'package:intl/intl.dart';
import 'package:logbook/logbook.dart';
import 'package:ui/ui.dart' show StringNull$X;

extension DateTimeX on DateTime {
  bool isSameDay(DateTime? other) {
    if (other == null) return false;

    return year == other.year && month == other.month && day == other.day;
  }

  /// Example: "2026-01-03T16:53:59Z" -> "Fri, Jan 3rd"
  String get formatWithDay {
    final dayFormat = DateFormat('EEE, MMM'); // "Sun, Jan"

    return '${dayFormat.format(this)} $day${_daySuffix(day)}';
  }

  /// Example: "2026-01-03T16:53:59Z" -> "Friday, January 3rd 2026"
  String get formatWithDaySuffix {
    final dayFormat = DateFormat('EEEE, MMMM'); // "Sunday, January"
    final yearFormat = DateFormat('y'); // "2026"

    return '${dayFormat.format(this)} $day${_daySuffix(day)} ${yearFormat.format(this)}';
  }

  String _daySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  /// Example: "2026-01-03T16:53:59Z" -> "2026-01-03T05:53:59-06:00"
  DateTime toGarbageCompanyDateTime({required final String companyTimeZone}) {
    final utc = toUtc();

    try {
      final offset = StringNull$X.usTZOffsets[companyTimeZone.toTimeZoneAbbreviation] ?? '';
      final offsetMatchGroup = RegExp(r'([-+])(\d\d)(?::?(\d\d))?$').firstMatch(offset);

      final offsetSign = offsetMatchGroup?.group(1) ?? '+';
      final offsetHours = int.tryParse(offsetMatchGroup?.group(2) ?? '00') ?? 0;
      final offsetMinutes = int.tryParse(offsetMatchGroup?.group(3) ?? '00') ?? 0;

      final sign = offsetSign == '+' ? 1 : -1;
      final timezoneOffset = sign * (offsetHours * 60 + offsetMinutes);

      return utc.copyWith(minute: utc.minute + timezoneOffset);
    } on Object catch (e, s) {
      l.s('toGarbageCompanyDateTime > error: $e', s);
      return utc;
    }
  }

  /// Example: "2026-01-03T16:53:59" -> "2026-01-03 05:53:59 CST"
  String toGarbageCompanyString({required final String companyTimeZone}) {
    final companyDateTime = toGarbageCompanyDateTime(companyTimeZone: companyTimeZone);
    return '${DateFormat('yyyy-MM-dd HH:mm:ss').format(companyDateTime)} ${companyTimeZone.toTimeZoneAbbreviation}';
  }
}

extension TimerX on int {
  /// Converts the timer to a time string.
  String get timerToTimeString {
    final minutes = this ~/ 60;
    final seconds = this % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

extension DurationX on Duration {
  String get formatDuration {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final minutes = twoDigits(inMinutes.remainder(60));
    final seconds = twoDigits(inSeconds.remainder(60));

    return '$minutes:$seconds';
  }
}
