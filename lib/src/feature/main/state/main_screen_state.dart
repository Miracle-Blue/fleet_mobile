part of '../screen/main_screen.dart';

abstract class MainScreenState extends State<MainScreen> {
  InAppWebViewController? controller;

  void onWebViewCreated(InAppWebViewController controller) {
    this.controller = controller;
  }

  URLRequest get initialUrlRequest => URLRequest(url: WebUri(Config.apiBaseUrl));

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
