import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../border/smooth_rectangle_border.dart';
import '../service/haptics_service.dart';
import '../theme/theme.dart';
import 'button_state.dart';

/// {@template button_fill}
/// ButtonFill widget.
/// {@endtemplate}
class ButtonFill extends StatelessWidget {
  /// {@macro button_fill}
  const ButtonFill({
    required this.onPressed,
    required this.child,
    this.feedback = HapticsService.selectionClick,
    this.borderSide,
    this.state = ButtonState.inactive,
    this.color = const Color(0xFF1C60E8),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    super.key, // ignore: unused_element
  });

  final Color color;
  final BorderSide? borderSide;
  final ButtonState state;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final VoidCallback? feedback;
  final void Function()? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) => CupertinoButton(
    sizeStyle: CupertinoButtonSize.medium,
    minimumSize: const Size(400, 48),
    borderRadius: BorderRadius.zero,
    padding: EdgeInsets.zero,
    onPressed: state.maybeMapOrNull<VoidCallback?>(
      active: () => () {
        feedback?.call();
        onPressed?.call();
      },
    ),
    child: Material(
      clipBehavior: Clip.antiAlias,
      shape: SmoothRectangleBorders(smoothness: .7, borderRadius: borderRadius, side: borderSide ?? BorderSide.none),
      color: state.map<Color>(
        active: () => color,
        processing: () => color.withValues(alpha: 0.5),
        inactive: () => color.withValues(alpha: 0.5),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: Opacity(
          opacity: state.maybeMap<double>(active: () => 1, processing: () => 1, orElse: () => 0.4),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Center(
              child: state.maybeMap(
                orElse: () => child,
                processing: () => SizedBox.square(
                  dimension: 24,
                  child: RepaintBoundary(
                    child: CircularProgressIndicator(
                      strokeCap: StrokeCap.round,
                      color: Theme.of(context).appColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
