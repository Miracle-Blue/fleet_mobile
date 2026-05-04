import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:ui/ui.dart';

/// {@template splash_screen}
/// Very simple splash screen with a pulse animation.
/// {@endtemplate}
class SplashScreen extends StatefulWidget {
  /// {@macro splash_screen}
  const SplashScreen({required this.progress, required this.gradient, super.key});

  /// The progress of the initialization.
  final ValueListenable<({int progress, String message})> progress;

  /// The gradient to use for the background.
  /// (Ignored in this simple version)
  final ui.FragmentShader gradient;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLightMode = View.of(context).platformDispatcher.platformBrightness == Brightness.light;
    final theme = isLightMode ? AppThemeData.light() : AppThemeData.dark();

    return Material(
      color: theme.appColors.primary,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.1).animate(_animation),
            child: AppText.w700s28('Fleet Mobile', color: theme.appColors.white),
          ),
        ),
      ),
    );
  }
}
