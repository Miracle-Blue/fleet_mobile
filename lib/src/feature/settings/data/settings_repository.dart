import 'package:ui/ui.dart';

import '../model/app_settings.dart';

/// {@template app_settings_repository}
/// [AppSettingsRepository] sets and gets app settings.
/// {@endtemplate}
abstract interface class ISettingsRepository {
  /// Set app settings
  Future<void> setSettings(AppSettings settings);

  /// Load [AppSettings] from the source of truth.
  Future<AppSettings?> getSettings();
}

/// {@macro app_settings_repository}
final class SettingsRepositoryImpl implements ISettingsRepository {
  /// {@macro app_settings_repository}
  const SettingsRepositoryImpl();

  @override
  Future<AppSettings?> getSettings() async {
    // TODO: implement getSettings
    const localization = Locale('ru');
    const themeMode = ThemeMode.system;
    const hapticsEnabled = false;

    return const AppSettings(localization: localization, hapticsEnabled: hapticsEnabled, themeMode: themeMode);
  }

  @override
  Future<void> setSettings(AppSettings settings) async {}
}
