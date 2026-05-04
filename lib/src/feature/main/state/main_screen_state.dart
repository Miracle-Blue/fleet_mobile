part of '../screen/main_screen.dart';

abstract class MainScreenState extends State<MainScreen> {
  InAppWebViewController? controller;
  PullToRefreshController? pullToRefreshController;

  double progress = 0;
  bool isError = false;

  final InAppWebViewSettings settings = InAppWebViewSettings(
    isInspectable: false,
    userAgent: Platform.isIOS
        ? 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_1_2 like Mac OS X) AppleWebKit/605.1.15'
              ' (KHTML, like Gecko) Version/13.0.1 Mobile/15E148 Safari/604.1'
        : 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) '
              'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36',
    mediaPlaybackRequiresUserGesture: true,
    allowsInlineMediaPlayback: true,
    iframeAllow: 'camera; microphone',
    iframeAllowFullscreen: true,
    useShouldOverrideUrlLoading: true,
    supportZoom: false,
    builtInZoomControls: false,
    displayZoomControls: false,
    pageZoom: 1,
    maximumZoomScale: 1,
    minimumZoomScale: 1,
    allowsBackForwardNavigationGestures: false,
    cacheEnabled: false, // (kross-platform)
    cacheMode: CacheMode.LOAD_NO_CACHE, // (Android-ga xos)
    javaScriptEnabled: true,
    preferredContentMode: UserPreferredContentMode.MOBILE,
    allowsLinkPreview: false,
    useOnLoadResource: true,
    transparentBackground: true,
  );

  Future<void> onPopInvokedWithResult(bool didPop, _) async {
    if (didPop) return;
    final canGoBack = await controller?.canGoBack() ?? false;
    if (canGoBack) {
      await controller?.goBack();
    }
  }

  @override
  void initState() {
    super.initState();

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

  void onWebViewCreated(InAppWebViewController controller) {
    this.controller = controller;
    pullToRefreshController?.setEnabled(true);
  }

  void onLoadStart(_, _) => setState(() => isError = false);

  Future<void> onLoadStop(_, _) async => await pullToRefreshController?.endRefreshing();

  void onProgressChanged(_, int progress) {
    if (progress == 100) pullToRefreshController?.endRefreshing();
    setState(() => this.progress = progress / 100);
  }

  void onReceivedError(_, _, _) => setState(() => isError = true);

  Future<NavigationActionPolicy?> shouldOverrideUrlLoading(_, NavigationAction navigationAction) async {
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

  Future<PermissionResponse?> onPermissionRequest(_, PermissionRequest permissionRequest) async =>
      PermissionResponse(resources: permissionRequest.resources, action: PermissionResponseAction.GRANT);

  URLRequest get initialUrlRequest => URLRequest(url: WebUri(Config.apiBaseUrl));

  @override
  void dispose() {
    super.dispose();
  }
}
