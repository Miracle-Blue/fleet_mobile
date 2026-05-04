part of '../../screen/main_screen.dart';

mixin MainScreenProgressMixin on State<MainScreen>, MainScreenRefreshMixin {
  double progress = 0;

  Future<void> onLoadStop(_, _) async => await pullToRefreshController?.endRefreshing();

  void onProgressChanged(_, int progress) {
    if (progress == 100) pullToRefreshController?.endRefreshing();
    setState(() => this.progress = progress / 100);
  }
}
