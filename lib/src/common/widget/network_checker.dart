import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ui/ui.dart';

/// {@template network_checker}
/// A wrapper widget that listens to network connectivity.
/// If there is no connection, it overlays a "No Connection" page.
/// {@endtemplate}
class NetworkChecker extends StatefulWidget {
  /// {@macro network_checker}
  const NetworkChecker({required this.child, super.key});

  /// The child widget to display when there is a connection.
  final Widget child;

  @override
  State<NetworkChecker> createState() => _NetworkCheckerState();
}

class _NetworkCheckerState extends State<NetworkChecker> {
  late final StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _hasConnection = true;

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();
    _subscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _checkInitialConnection() async {
    final result = await Connectivity().checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    final noConnection = result.length == 1 && result.first == ConnectivityResult.none;
    final hasConnection = !noConnection;
    if (_hasConnection != hasConnection) {
      setState(() {
        _hasConnection = hasConnection;
      });
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      widget.child,
      if (!_hasConnection)
        Positioned.fill(
          child: Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.wifi_off_rounded, size: 80, color: Theme.of(context).colorScheme.error),
                    const SizedBox(height: 24),
                    AppText.w700s28('No Connection', textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    AppText.w400s16('Please check your internet settings.', textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ),
        ),
    ],
  );
}
