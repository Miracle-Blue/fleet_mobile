import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart' show Ticker;
import 'package:ui/ui.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({required this.progress, required this.gradient, super.key});

  final ValueListenable<({int progress, String message})> progress;
  final ui.FragmentShader gradient;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future<void>.delayed(const Duration(milliseconds: 500), () => setState(() => _isInitialized = true));
  }

  @override
  Widget build(BuildContext context) {
    final isLightMode = View.of(context).platformDispatcher.platformBrightness == Brightness.light;
    final theme = isLightMode ? AppThemeData.light() : AppThemeData.dark();

    return Material(
      color: theme.appColors.onPrimary,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background gradient
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: _isInitialized
                    ? SplashGradient(splashShader: widget.gradient, isLightMode: isLightMode)
                    : const SizedBox.shrink(),
              ),
            ),
            // Text
            Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _isInitialized
                    ? AppText.w700s28('SUN ELD', color: theme.appColors.white)
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// {@template splash_gradient}
/// SplashGradient widget.
/// {@endtemplate}
class SplashGradient extends StatefulWidget {
  /// {@macro splash_gradient}
  const SplashGradient({
    required this.splashShader,
    required this.isLightMode,
    super.key, // ignore: unused_element
  });

  final ui.FragmentShader splashShader;
  final bool isLightMode;

  @override
  State<SplashGradient> createState() => _SplashGradientState();
}

/// State for widget SplashGradient.
class _SplashGradientState extends State<SplashGradient> with SingleTickerProviderStateMixin {
  late Ticker? _ticker;

  double _time = 0;

  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();

    _ticker = createTicker((elapsed) {
      setState(() => _time = elapsed.inMilliseconds / 2000);
    });

    _ticker?.start();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _ticker = null;

    super.dispose();
  }
  /* #endregion */

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: CustomPaint(
      size: Size.infinite,
      painter: GradientPainter(shader: widget.splashShader, time: _time, isLightMode: widget.isLightMode),
    ),
  );
}

class GradientPainter extends CustomPainter {
  GradientPainter({required this.shader, required this.time, required this.isLightMode});

  final ui.FragmentShader shader;
  final double time;
  final bool isLightMode;

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, time)
      ..setFloat(3, isLightMode ? 1 : 0);

    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(GradientPainter oldDelegate) => oldDelegate.time != time;
}
