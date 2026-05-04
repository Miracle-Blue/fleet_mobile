part of '../main_screen_state.dart';

mixin MainScreenNavigationMixin on State<MainScreen>, MainScreenControllerMixin {
  Future<void> onPopInvokedWithResult(bool didPop, _) async {
    if (didPop) return;
    final canGoBack = await controller?.canGoBack() ?? false;
    if (canGoBack) {
      await controller?.goBack();
    }
  }

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
}
