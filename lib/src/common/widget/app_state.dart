part of 'app.dart';

/// State for widget App.
abstract class AppState extends State<App> with AppDebugConfigInitialization {
  final GlobalKey<State<StatefulWidget>> _appKey = GlobalKey<State<StatefulWidget>>();

  // #region lifecycle
  // initState works -> AppRouteInitialization -> AppDebugConfigInitialization -> AppState
  @override
  void initState() {
    super.initState();

    Future<void>.delayed(const Duration(seconds: 1), _appSettingsListener).ignore();
  }

  // #endregion lifecycle
}
