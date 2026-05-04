part of '../screen/main_screen.dart';

abstract class MainScreenState extends State<MainScreen>
    with
        MainScreenControllerMixin,
        MainScreenNavigationMixin,
        MainScreenRefreshMixin,
        MainScreenProgressMixin,
        MainScreenErrorMixin,
        MainScreenPermissionMixin {
  void onWebViewCreated(InAppWebViewController controller) {
    this.controller = controller;
    pullToRefreshController?.setEnabled(true);
  }
}
