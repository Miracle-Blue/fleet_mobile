import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/constant/config.dart';
import '../../../common/extension/context_extension.dart';
import '../../../common/widget/network_checker.dart';
import '../state/main_screen_state.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends MainScreenState {
  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    onPopInvokedWithResult: onPopInvokedWithResult,
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
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.transparent,
                    color: context.x.theme.primaryColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
