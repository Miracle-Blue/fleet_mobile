import 'dart:async';
import 'dart:collection';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

import 'package:logbook/logbook.dart';
import 'package:path_provider/path_provider.dart';
import 'package:platform_info/platform_info.dart';

import '../../../feature/settings/controller/settings_controller.dart';
import '../../../feature/settings/data/settings_repository.dart';
import '../../../feature/settings/model/app_settings.dart';
import '../../constant/config.dart';
import '../../constant/pubspec.yaml.g.dart';
import '../../service/remote_config_service.dart';
import '../../service/telegram_bot_error_logger.dart';
import '../../util/screen_util.dart';
import '../model/app_metadata.dart';
import '../model/debug_config.dart';
import '../model/dependencies.dart';
import '../model/firebase_remote_config_values.dart';

/// Initializes the app and returns a [Dependencies] object
Future<Dependencies> $initializeDependencies({void Function(int progress, String message)? onProgress}) async {
  final dependencies = Dependencies();
  final totalSteps = _initializationSteps.length;
  var currentStep = 0;
  for (final step in _initializationSteps) {
    try {
      currentStep++;
      final percent = (currentStep * 100 ~/ totalSteps).clamp(0, 100);
      onProgress?.call(percent, step.$1);
      l.i('Initialization | $currentStep/$totalSteps ($percent%) | "${step.$1}"');
      await step.$2(dependencies);
    } on Object catch (error, stackTrace) {
      l.s('Initialization failed at step "${step.$1}": $error', stackTrace);
      Error.throwWithStackTrace('Initialization failed at step "${step.$1}": $error', stackTrace);
    }
  }
  return dependencies;
}

typedef _InitializationStep = FutureOr<void> Function(Dependencies dependencies);

List<(String, _InitializationStep)> get _initializationSteps => <(String, _InitializationStep)>[
  (
    'Platform pre-initialization',
    (_) {
      /// initializing Firebase
      try {
        // TODO(miracle-blue): Add Firebase
        // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      } on Object catch (err, stackTrace) {
        l.s(err, stackTrace);
      }
    },
  ),

  (
    'Creating app metadata',
    (dependencies) => dependencies.metadata = AppMetadata(
      environment: Config.environment.value,
      isWeb: platform.type.js,
      isRelease: platform.buildMode.release,
      appName: Pubspec.name,
      appVersion: Pubspec.version.canonical,
      appVersionMajor: Pubspec.version.major,
      appVersionMinor: Pubspec.version.minor,
      appVersionPatch: Pubspec.version.patch,
      appBuildTimestamp: Pubspec.version.build.isNotEmpty
          ? (int.tryParse(Pubspec.version.build.firstOrNull ?? '-1') ?? -1)
          : -1,
      operatingSystem: platform.operatingSystem.name,
      processorsCount: platform.numberOfProcessors,
      appLaunchedTimestamp: DateTime.now(),
      locale: platform.locale,
      deviceVersion: platform.version,
      deviceScreenSize: ScreenUtil.screenSize().representation,
    ),
  ),

  (
    'App Initial Settings',
    (dependencies) {
      // TODO: get localization from local storage
      const localization = Locale('ru');

      dependencies.settingsController = SettingsController(
        settingsRepository: const SettingsRepositoryImpl(),
        initialSettings: const AppSettings(
          localization: localization,
          hapticsEnabled: false,
          themeMode: ThemeMode.system,
        ),
      );
    },
  ),

  (
    'App Debug Settings',
    (dependencies) async {
      try {
        final remoteConfigService = await RemoteConfigService.instance();
        final botConfig = remoteConfigService.getBotConfig();

        dependencies.appDebugSettings = ValueNotifier(DebugConfig.fromJson(botConfig));

        l.i('App Debug Settings: ${dependencies.appDebugSettings.value}');
      } on Object catch (error, stackTrace) {
        dependencies.appDebugSettings = ValueNotifier(const DebugConfig(debuggerEnabled: false));

        l.s('Error initializing App Debug Settings: $error', stackTrace);
      }
    },
  ),

  (
    'Telegram Bot Error Logger',
    (dependencies) async {
      final plugin = DeviceInfoPlugin();

      final deviceInfo = await () async {
        if (Platform.I.iOS) {
          final ios = await plugin.iosInfo;

          return DeviceInfo(device: ios.modelName, os: ios.systemName, appVersion: Pubspec.version.canonical);
        } else if (Platform.I.android) {
          final android = await plugin.androidInfo;

          return DeviceInfo(device: android.model, os: android.version.release, appVersion: Pubspec.version.canonical);
        } else if (Platform.I.macOS) {
          final macOs = await plugin.macOsInfo;

          return DeviceInfo(device: macOs.model, os: macOs.osRelease, appVersion: Pubspec.version.canonical);
        }

        return null;
      }();

      dependencies.logger = TelegramBotErrorLogger(
        deviceInfo: deviceInfo,
        botToken: dependencies.appDebugSettings.value.telegramBotToken ?? '',
        chatId: dependencies.appDebugSettings.value.telegramChatId ?? '',
        tempDirectoryPath: (await getTemporaryDirectory()).path,
      );
    },
  ),

  (
    'Firebase Remote Config Values',
    (dependencies) async {
      try {
        final remoteConfigService = await RemoteConfigService.instance();

        final appVersion = remoteConfigService.isCallCheckAppVersion(dependencies);

        final supportLink = remoteConfigService.getSupportLink();

        final userManualLink = remoteConfigService.getUserManualLink();

        dependencies.firebaseRemoteConfigValues = FirebaseRemoteConfigValues(
          updateData: appVersion,
          supportLink: supportLink,
          userManualLink: userManualLink,
        );
      } on Object catch (error, stackTrace) {
        l.s('Error initializing Firebase Remote Config Values: $error', stackTrace);
        dependencies.firebaseRemoteConfigValues = const FirebaseRemoteConfigValues(
          updateData: (appUpdate: AppUpdate.none, oldVersion: '', newVersion: ''),
          supportLink: '',
          userManualLink: '',
        );
      }
    },
  ),

  (
    'Repositories',
    (dependencies) {
      dependencies.repository = RepositoryContainer();
    },
  ),

  (
    'Load Data If User Is Authenticated',
    (dependencies) async {
      await Future<void>.delayed(const Duration(seconds: 3));
    },
  ),
];
