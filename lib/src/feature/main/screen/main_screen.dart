import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/constant/config.dart';
import '../../../common/extension/context_extension.dart';

part '../state/main_screen_state.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends MainScreenState {
  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, result) async {
      if (didPop) return;
      final canGoBack = await controller?.canGoBack() ?? false;
      if (canGoBack) {
        await controller?.goBack();
      }
    },
    child: Scaffold(
      backgroundColor: context.x.theme.primaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: initialUrlRequest,
              initialSettings: settings,
              pullToRefreshController: pullToRefreshController,
              onWebViewCreated: onWebViewCreated,
              onLoadStart: onLoadStart,
              onLoadStop: onLoadStop,
              onProgressChanged: onProgressChanged,
              onReceivedError: onReceivedError,
              shouldOverrideUrlLoading: shouldOverrideUrlLoading,
              onPermissionRequest: onPermissionRequest,
            ),
            if (progress < 1.0)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.transparent,
                  color: Theme.of(context).primaryColor,
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
