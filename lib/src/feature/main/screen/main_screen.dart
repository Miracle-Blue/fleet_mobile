import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../common/constant/config.dart';

part '../state/main_screen_state.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends MainScreenState {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: InAppWebView(onWebViewCreated: onWebViewCreated, initialUrlRequest: initialUrlRequest),
  );
}
