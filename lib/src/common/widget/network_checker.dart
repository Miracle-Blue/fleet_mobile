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

  /// The stream of connectivity results.
  static Stream<bool> get hasConnectionStream => Connectivity().onConnectivityChanged.asBroadcastStream().transform(
    StreamTransformer.fromHandlers(
      handleData: (data, sink) => sink.add(data.hasConnection),
      handleError: (error, stackTrace, sink) => sink.addError(error, stackTrace),
      handleDone: (sink) => sink.close(),
    ),
  );

  @override
  State<NetworkChecker> createState() => _NetworkCheckerState();
}

class _NetworkCheckerState extends State<NetworkChecker> {
  @override
  Widget build(BuildContext context) => Stack(
    children: [
      widget.child,
      StreamBuilder<bool>(
        initialData: true,
        stream: NetworkChecker.hasConnectionStream,
        builder: (_, snapshot) => snapshot.data ?? false
            ? const SizedBox.shrink()
            : Positioned.fill(
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
      ),
    ],
  );
}

extension on List<ConnectivityResult> {
  bool get noConnection => length == 1 && first == ConnectivityResult.none;
  bool get hasConnection => !noConnection;
}
