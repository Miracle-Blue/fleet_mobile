import 'package:flutter/foundation.dart';
import '../../../feature/settings/controller/settings_controller.dart';
import '../../service/telegram_bot_error_logger.dart';
import 'app_metadata.dart';
import 'debug_config.dart';
import 'firebase_remote_config_values.dart';

/// {@template dependencies}
/// Application dependencies.
/// {@endtemplate}
class Dependencies {
  /// {@macro dependencies}
  Dependencies();

  /// App metadata
  late final AppMetadata metadata;

  // /// [SettingsController] for app settings
  // late final SettingsController settingsController;

  /// [RepositoryContainer] for repositories
  late final RepositoryContainer repository;

  /// [Mixpanel] for analytics
  // late final Mixpanel mixpanel;

  /// [SettingsController] for app settings
  late final SettingsController settingsController;

  /// [TelegramBotErrorLogger] for telegram bot error logging
  late final TelegramBotErrorLogger logger;

  /// [FirebaseRemoteConfigValues] for firebase remote config values
  late final FirebaseRemoteConfigValues firebaseRemoteConfigValues;

  /// [DebugConfig] for app debug settings
  late final ValueNotifier<DebugConfig> appDebugSettings;

  @override
  String toString() => 'Dependencies{}';
}

/// [RepositoryContainer] is a container for Repository instances.
final class RepositoryContainer {
  RepositoryContainer();
}
