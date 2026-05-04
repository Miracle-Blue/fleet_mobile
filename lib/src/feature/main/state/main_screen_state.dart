

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ui/ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/constant/config.dart';
import '../../../common/widget/network_checker.dart';
import '../screen/main_screen.dart';

part 'mixin/main_screen_controller_mixin.dart';
part 'mixin/main_screen_navigation_mixin.dart';
part 'mixin/main_screen_refresh_mixin.dart';
part 'mixin/main_screen_progress_mixin.dart';
part 'mixin/main_screen_error_mixin.dart';
part 'mixin/main_screen_permission_mixin.dart';


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
