import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ui/ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/constant/config.dart';
import '../../../common/extension/context_extension.dart';
import '../../../common/widget/network_checker.dart';
import '../../settings/screen/update_app_dialog.dart';
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
  bool _updateDialogShown = false;

  void _showUpdateDialogIfNeeded() {
    if (!mounted || _updateDialogShown) return;

    final updateData = context.x.dependencies.firebaseRemoteConfigValues.updateData;
    if (!updateData.appUpdate.isSoftUpdate) return;

    _updateDialogShown = true;
    unawaited(showDialog<void>(context: context, builder: (_) => const UpdateAppDialog()));
  }

  void onWebViewCreated(InAppWebViewController controller) {
    this.controller = controller;
    pullToRefreshController?.setEnabled(true);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showUpdateDialogIfNeeded());
  }
}
