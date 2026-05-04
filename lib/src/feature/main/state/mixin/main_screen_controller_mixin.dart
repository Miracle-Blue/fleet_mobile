part of '../main_screen_state.dart';

mixin MainScreenControllerMixin on State<MainScreen> {
  InAppWebViewController? controller;

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

  URLRequest get initialUrlRequest => URLRequest(url: WebUri(Config.apiBaseUrl));
}
