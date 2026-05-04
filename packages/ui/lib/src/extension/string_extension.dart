extension StringNull$X on String? {
  static Map<String, String> get usTZOffsets => {
    'EST': '-05:00', // Eastern Standard
    'EDT': '-04:00', // Eastern Daylight
    'CST': '-06:00', // Central Standard
    'CDT': '-05:00', // Central Daylight
    'MST': '-07:00', // Mountain Standard
    'MDT': '-06:00', // Mountain Daylight
    'PST': '-08:00', // Pacific Standard
    'PDT': '-07:00', // Pacific Daylight
    'AKST': '-09:00', // Alaska Standard
    'AKDT': '-08:00', // Alaska Daylight
    'HST': '-10:00', // Hawaii (no DST)
    'AST': '-04:00', // Atlantic Standard (Puerto Rico, US Virgin Islands)
  };

  String get getTimeZoneOffset => usTZOffsets[this] ?? '';

  // Normalize the date string to ISO 8601 format
  // Format: "2025-08-25 19:14:29 UTC" -> "2025-08-25T19:14:29Z"
  // Example: "2026-01-03 05:53:59 CST" -> "2026-01-03T05:53:59-06:00"
  // Example: "2026-01-18 07:25:04 +0000 UTC" -> "2026-01-18T07:25:04Z"
  DateTime? get fromGarbageToLocal {
    final dateString = this;

    if (dateString == null || dateString.isEmpty) return null;

    final normalized = dateString
        .replaceAll(
          RegExp(r'([+-]\d{4}) [a-zA-Z]+$'),
          r'$1',
        ) // Remove trailing TZ name when offset is present: "+0000 UTC" -> "+0000"
        .replaceAllMapped(
          RegExp(r' ([a-zA-Z]{3,4})$'),
          (match) => usTZOffsets[match[1] ?? ''] ?? '',
        ) // Replace " UTC", " PST", " MST", " CST", " HST" with "TZ offset"
        .replaceFirst(' ', 'T'); // Replace first space (between date and time) with "T"

    final utc = DateTime.tryParse(normalized);
    if (utc == null) return null;
    return DateTime.utc(
      utc.year,
      utc.month,
      utc.day,
      utc.hour,
      utc.minute,
      utc.second,
      utc.millisecond,
      utc.microsecond,
    ).toLocal();
  }

  DateTime? get fromGarbageToCompanyDateTime {
    final dateString = this;

    if (dateString == null || dateString.isEmpty) return null;

    final timeZone = dateString.split(' ').lastOrNull ?? '';
    final offset = usTZOffsets[timeZone] ?? '';
    if (offset.isEmpty) return null;

    final offsetMatchGroup = RegExp(r'([-+])(\d\d)(?::?(\d\d))?$').firstMatch(offset);

    final offsetSign = offsetMatchGroup?.group(1) ?? '+';
    final offsetHours = int.tryParse(offsetMatchGroup?.group(2) ?? '00') ?? 0;
    final offsetMinutes = int.tryParse(offsetMatchGroup?.group(3) ?? '00') ?? 0;

    final sign = offsetSign == '+' ? 1 : -1;
    final timezoneOffset = sign * (offsetHours * 60 + offsetMinutes);

    final normalized = dateString
        .replaceAll(
          RegExp(r'([+-]\d{4}) [a-zA-Z]+$'),
          r'$1',
        ) // Remove trailing TZ name when offset is present: "+0000 UTC" -> "+0000"
        .replaceAllMapped(
          RegExp(r' ([a-zA-Z]{3,4})$'),
          (match) => usTZOffsets[match[1] ?? ''] ?? '',
        ) // Replace " UTC", " PST", " MST", " CST", " HST" with "TZ offset"
        .replaceFirst(' ', 'T'); // Replace first space (between date and time) with "T"

    final dateTimeUtc = DateTime.tryParse(normalized)?.toUtc();
    if (dateTimeUtc == null) return null;

    return dateTimeUtc.copyWith(minute: dateTimeUtc.minute + timezoneOffset);
  }

  /// Extension for time zone conversions between long names and short abbreviations.
  String get toTimeZoneAbbreviation => switch (this) {
    // Eastern
    'America/New_York' => 'EST',

    // Central
    'America/Chicago' => 'CST',

    // Mountain
    'America/Denver' => 'MST',

    // Hawaii
    'Pacific/Honolulu' => 'HST',

    // Pacific
    'America/Los_Angeles' => 'PST',

    // Alaska
    'America/Anchorage' => 'AKST',

    // Atlantic (Puerto Rico, US Virgin Islands)
    'America/Puerto_Rico' => 'AST',
    _ => this ?? '',
  };

  // Example: "CST" -> "America/Chicago"
  String get toTimeZoneLongName => switch (this?.toUpperCase()) {
    // Eastern
    'EST' => 'America/New_York',
    'EDT' => 'America/New_York',

    // Central
    'CST' => 'America/Chicago',
    'CDT' => 'America/Chicago',

    // Mountain
    'MST' => 'America/Denver',
    'MDT' => 'America/Denver',

    // Pacific
    'PST' => 'America/Los_Angeles',
    'PDT' => 'America/Los_Angeles',

    // Alaska
    'AKST' => 'America/Anchorage',
    'AKDT' => 'America/Anchorage',

    // Hawaii
    'HST' => 'Pacific/Honolulu',

    // Atlantic (Puerto Rico, US Virgin Islands)
    'AST' => 'America/Puerto_Rico',
    _ => this ?? '',
  };
}
