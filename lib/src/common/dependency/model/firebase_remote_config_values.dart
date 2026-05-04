import 'package:meta/meta.dart';

import '../../service/remote_config_service.dart';

/// {@template firebase_remote_config_values}
/// Firebase remote config values.
/// {@endtemplate}
@immutable
final class FirebaseRemoteConfigValues {
  /// {@macro firebase_remote_config_values}
  const FirebaseRemoteConfigValues({required this.updateData, required this.supportLink, required this.userManualLink});

  final ({AppUpdate appUpdate, String oldVersion, String newVersion}) updateData;
  final String supportLink;
  final String userManualLink;

  FirebaseRemoteConfigValues copyWith({
    ({AppUpdate appUpdate, String oldVersion, String newVersion})? updateData,
    String? supportLink,
    String? userManualLink,
  }) => FirebaseRemoteConfigValues(
    updateData: updateData ?? this.updateData,
    supportLink: supportLink ?? this.supportLink,
    userManualLink: userManualLink ?? this.userManualLink,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FirebaseRemoteConfigValues &&
        other.updateData == updateData &&
        other.supportLink == supportLink &&
        other.userManualLink == userManualLink;
  }

  @override
  int get hashCode => updateData.hashCode ^ supportLink.hashCode ^ userManualLink.hashCode;

  @override
  String toString() =>
      '''FirebaseRemoteConfigValues(updateData: $updateData, supportLink: $supportLink, userManualLink: $userManualLink)''';
}
