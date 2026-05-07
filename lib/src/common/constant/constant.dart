import 'dart:io' as io;

class Constant {
  const Constant._();

  static final appLink = (io.Platform.isIOS || io.Platform.isMacOS)
      ? 'https://apps.apple.com/search?term=Sun%20Fleet'
      : 'https://play.google.com/store/apps/details?id=sun.fleet.mobile';
}
