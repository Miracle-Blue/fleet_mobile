part of '../../screen/main_screen.dart';

mixin MainScreenErrorMixin on State<MainScreen> {
  bool isError = false;

  void onLoadStart(_, _) => setState(() => isError = false);

  void onReceivedError(_, _, _) => setState(() => isError = true);
}
