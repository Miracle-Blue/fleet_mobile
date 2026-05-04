import 'package:flutter/foundation.dart';

import '../extension/string_extension.dart';

@immutable
final class Violation {
  const Violation({
    required this.id,
    required this.key,
    required this.logId,
    required this.startTime,
    required this.endTime,
  });

  factory Violation.fromJson(Map<String, Object?> json) => Violation(
    id: json['id']?.toString() ?? '',
    key: json['key']?.toString() ?? '',
    logId: json['logId']?.toString() ?? '',
    startTime: (json['startTime'] as String?)?.fromGarbageToLocal ?? DateTime.now(),
    endTime: (json['endTime'] as String?)?.fromGarbageToLocal ?? DateTime.now(),
  );

  final String id;
  final String key;
  final String logId;
  final DateTime startTime;
  final DateTime endTime;

  Violation copyWith({
    ValueGetter<String>? id,
    ValueGetter<String>? key,
    ValueGetter<String>? logId,
    ValueGetter<DateTime>? startTime,
    ValueGetter<DateTime>? endTime,
  }) => Violation(
    id: id != null ? id() : this.id,
    key: key != null ? key() : this.key,
    logId: logId != null ? logId() : this.logId,
    startTime: startTime != null ? startTime() : this.startTime,
    endTime: endTime != null ? endTime() : this.endTime,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Violation &&
          id == other.id &&
          key == other.key &&
          logId == other.logId &&
          startTime == other.startTime &&
          endTime == other.endTime;

  @override
  int get hashCode => Object.hash(id, key, logId, startTime, endTime);

  @override
  String toString() => 'Violation(id: $id, key: $key, logId: $logId, startTime: $startTime, endTime: $endTime)';
}

/// {@template violation_data}
/// ViolationKey enumeration
/// {@endtemplate}
enum ViolationKey implements Comparable<ViolationKey> {
  breakLimit('break_limit'),
  drivingLimit('driving_limit'),
  shiftLimit('shift_limit'),
  cycleLimit('cycle_limit'),
  breakLimitWarning('break_limit_warning'),
  drivingLimitWarning('driving_limit_warning'),
  shiftLimitWarning('shift_limit_warning'),
  cycleLimitWarning('cycle_limit_warning'),
  empty('empty');

  /// {@macro violation_data}
  const ViolationKey(this.value);

  /// Creates a new instance of [ViolationKey] from a given string.
  static ViolationKey fromValue(String? value, {ViolationKey? fallback}) => switch (value) {
    'break_limit' => breakLimit,
    'driving_limit' => drivingLimit,
    'shift_limit' => shiftLimit,
    'cycle_limit' => cycleLimit,
    'break_limit_warning' => breakLimitWarning,
    'driving_limit_warning' => drivingLimitWarning,
    'shift_limit_warning' => shiftLimitWarning,
    'cycle_limit_warning' => cycleLimitWarning,
    _ => fallback ?? empty,
  };

  /// Value of the enum
  final String value;

  /// Pattern matching
  T map<T>({
    required T Function() breakLimit,
    required T Function() drivingLimit,
    required T Function() shiftLimit,
    required T Function() cycleLimit,
    required T Function() breakLimitWarning,
    required T Function() drivingLimitWarning,
    required T Function() shiftLimitWarning,
    required T Function() cycleLimitWarning,
    required T Function() empty,
  }) => switch (this) {
    ViolationKey.breakLimit => breakLimit(),
    ViolationKey.drivingLimit => drivingLimit(),
    ViolationKey.shiftLimit => shiftLimit(),
    ViolationKey.cycleLimit => cycleLimit(),
    ViolationKey.breakLimitWarning => breakLimitWarning(),
    ViolationKey.drivingLimitWarning => drivingLimitWarning(),
    ViolationKey.shiftLimitWarning => shiftLimitWarning(),
    ViolationKey.cycleLimitWarning => cycleLimitWarning(),
    ViolationKey.empty => empty(),
  };

  /// Pattern matching
  T maybeMap<T>({
    required T Function() orElse,
    T Function()? breakLimit,
    T Function()? drivingLimit,
    T Function()? shiftLimit,
    T Function()? cycleLimit,
    T Function()? breakLimitWarning,
    T Function()? drivingLimitWarning,
    T Function()? shiftLimitWarning,
    T Function()? cycleLimitWarning,
    T Function()? empty,
  }) => map<T>(
    breakLimit: breakLimit ?? orElse,
    drivingLimit: drivingLimit ?? orElse,
    shiftLimit: shiftLimit ?? orElse,
    cycleLimit: cycleLimit ?? orElse,
    breakLimitWarning: breakLimitWarning ?? orElse,
    drivingLimitWarning: drivingLimitWarning ?? orElse,
    shiftLimitWarning: shiftLimitWarning ?? orElse,
    cycleLimitWarning: cycleLimitWarning ?? orElse,
    empty: empty ?? orElse,
  );

  /// Pattern matching
  T? maybeMapOrNull<T>({
    T Function()? breakLimit,
    T Function()? drivingLimit,
    T Function()? shiftLimit,
    T Function()? cycleLimit,
    T Function()? breakLimitWarning,
    T Function()? drivingLimitWarning,
    T Function()? shiftLimitWarning,
    T Function()? cycleLimitWarning,
    T Function()? empty,
  }) => maybeMap<T?>(
    orElse: () => null,
    breakLimit: breakLimit,
    drivingLimit: drivingLimit,
    shiftLimit: shiftLimit,
    cycleLimit: cycleLimit,
    breakLimitWarning: breakLimitWarning,
    drivingLimitWarning: drivingLimitWarning,
    shiftLimitWarning: shiftLimitWarning,
    cycleLimitWarning: cycleLimitWarning,
    empty: empty,
  );

  @override
  int compareTo(ViolationKey other) => index.compareTo(other.index);

  @override
  String toString() => value;
}
