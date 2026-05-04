part of '../main_screen_state.dart';

mixin MainScreenRefreshMixin on State<MainScreen>, MainScreenControllerMixin {
  PullToRefreshController? pullToRefreshController;
  StreamSubscription<bool>? hasConnectionSubscription;

  // #region lifecycle
  // initState works -> MainScreenControllerMixin -> MainScreenNavigationMixin -> MainScreenRefreshMixin -> MainScreenProgressMixin -> MainScreenErrorMixin -> MainScreenPermissionMixin -> MainScreenState
  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(
        color: switch (defaultTargetPlatform) {
          TargetPlatform.iOS => Colors.white,
          _ => Colors.blue,
        },
      ),
      onRefresh: onRefresh,
    );

    hasConnectionSubscription = NetworkChecker.hasConnectionStream.listen((hasConnection) async {
      if (hasConnection) await onRefresh();
    });
  }

  Future<void> onRefresh() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await controller?.reload();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      await controller?.loadUrl(urlRequest: URLRequest(url: await controller?.getUrl()));
    }
  }

  // dispose works -> MainScreenState -> MainScreenPermissionMixin -> MainScreenErrorMixin -> MainScreenProgressMixin -> MainScreenRefreshMixin -> MainScreenNavigationMixin -> MainScreenControllerMixin
  @override
  void dispose() {
    hasConnectionSubscription?.cancel();
    super.dispose();
  }

  // #endregion lifecycle
}
