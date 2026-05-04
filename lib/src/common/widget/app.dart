import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:logbook/logbook.dart';
import 'package:ui/ui.dart';
import '../../feature/main/screen/main_screen.dart';
import '../../feature/settings/screen/settings_scope.dart';
import '../constant/config.dart';
import '../dependency/model/debug_config.dart';
import '../extension/context_extension.dart';

part 'app_debug_config_initialization.dart';
part 'app_state.dart';

/// {@template app}
/// App widget.
/// {@endtemplate}
class App extends StatefulWidget {
  /// {@macro app}
  const App({
    super.key, // ignore: unused_element
  });

  @override
  State<App> createState() => _AppState();
}

/// UI configuration for widget App.
class _AppState extends AppState {
  @override
  Widget build(BuildContext context) => MaterialApp(
    restorationScopeId: 'material_app',

    // TODO(mcodevs): Change this to l10n
    title: 'Fleet Mobile',
    debugShowCheckedModeBanner: false,

    // Localizations
    // localizationsDelegates: const <LocalizationsDelegate<Object?>>[
    //   GlobalMaterialLocalizations.delegate,
    //   GlobalWidgetsLocalizations.delegate,
    //   GlobalCupertinoLocalizations.delegate,
    //   AppLocalization.delegate,
    // ],
    // supportedLocales: AppLocalization.supportedLocales,
    locale: SettingsScope.settingsOf(context).localization,

    // Theme
    themeMode: SettingsScope.settingsOf(context, listen: true).themeMode,
    darkTheme: AppThemeData.dark(),
    theme: AppThemeData.light(),

    // Scopes
    builder: (context, child) =>
        /// This scope [MediaQuery] is used to handle the screen size and orientation
        MediaQuery(
          key: _appKey,
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: KeyboardDismisser(
            child: Logbook(config: _logbookConfig, child: child ?? const SizedBox.shrink()),
          ),
        ),
    home: const MainScreen(),
  );
}
