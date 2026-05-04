part of '../screen/main_screen.dart';

abstract class MainScreenState extends State<MainScreen> {
  InAppWebViewController? controller;
  PullToRefreshController? pullToRefreshController;

  double progress = 0;
  bool isError = false;

  late final InAppWebViewSettings settings;

  @override
  void initState() {
    super.initState();

    settings = InAppWebViewSettings(
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: 'camera; microphone',
      iframeAllowFullscreen: true,
      transparentBackground: true,
      useShouldOverrideUrlLoading: true,
      useOnLoadResource: true,
    );

    pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(color: Colors.blue),
      onRefresh: () async {
        if (defaultTargetPlatform == TargetPlatform.android) {
          await controller?.reload();
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          await controller?.loadUrl(urlRequest: URLRequest(url: await controller?.getUrl()));
        }
      },
    );
  }

  // ignore: use_setters_to_change_properties
  void onWebViewCreated(InAppWebViewController controller) {
    this.controller = controller;
  }

  void onLoadStart(InAppWebViewController controller, WebUri? url) {
    setState(() {
      isError = false;
    });
  }

  Future<void> onLoadStop(InAppWebViewController controller, WebUri? url) async {
    await pullToRefreshController?.endRefreshing();
  }

  void onProgressChanged(InAppWebViewController controller, int progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
    setState(() {
      this.progress = progress / 100;
    });
  }

  void onReceivedError(InAppWebViewController controller, WebResourceRequest request, WebResourceError error) {
    setState(() {
      isError = true;
    });
  }

  Future<NavigationActionPolicy?> shouldOverrideUrlLoading(
    InAppWebViewController controller,
    NavigationAction navigationAction,
  ) async {
    final uri = navigationAction.request.url;
    if (uri == null) return NavigationActionPolicy.ALLOW;

    final scheme = uri.scheme.toLowerCase();
    if (!['http', 'https', 'file', 'chrome', 'data', 'javascript', 'about'].contains(scheme)) {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return NavigationActionPolicy.CANCEL;
      }
    }
    return NavigationActionPolicy.ALLOW;
  }

  Future<PermissionResponse?> onPermissionRequest(
    InAppWebViewController controller,
    PermissionRequest permissionRequest,
  ) async => PermissionResponse(resources: permissionRequest.resources, action: PermissionResponseAction.GRANT);

  URLRequest get initialUrlRequest => URLRequest(url: WebUri(Config.apiBaseUrl));

  @override
  void dispose() {
    super.dispose();
  }
}
