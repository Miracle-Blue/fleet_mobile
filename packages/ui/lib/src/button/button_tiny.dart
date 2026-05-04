import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../border/smooth_rectangle_border.dart';
import '../service/haptics_service.dart';
import '../theme/theme.dart';
import 'border_status.dart';
import 'button_state.dart';

/// {@template button_tiny}
/// ButtonTiny widget.
/// {@endtemplate}
class ButtonTiny extends StatelessWidget {
  /// {@macro button_tiny}
  const ButtonTiny({
    required this.child,
    required this.onPressed,
    this.feedback = HapticsService.selectionClick,
    this.color = const Color(0xFF41484C),
    this.state = ButtonState.inactive,
    this.borderStatus = BorderStatus.none,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.borderStatusPainter,
    super.key, // ignore: unused_element
  });

  final Widget child;
  final Color color;
  final ButtonState state;
  final BorderStatus borderStatus;
  final BorderRadius borderRadius;
  final VoidCallback? feedback;
  final EdgeInsets padding;
  final CustomPainter? borderStatusPainter;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) => CupertinoButton(
    padding: EdgeInsets.zero,
    sizeStyle: CupertinoButtonSize.small,
    onPressed: state.maybeMapOrNull<VoidCallback?>(
      active: () => () {
        feedback?.call();
        onPressed?.call();
      },
    ),
    borderRadius: BorderRadius.zero,
    child: Material(
      clipBehavior: Clip.antiAlias,
      shape: SmoothRectangleBorders(
        smoothness: .7,
        borderRadius: borderRadius,
        side: state.maybeMap(
          orElse: () => BorderSide.none,
          active: () => borderStatus.map<BorderSide>(
            error: () => BorderSide(color: Theme.of(context).appColors.error, width: 1.5),
            success: () => BorderSide(color: Theme.of(context).appColors.success, width: 1.5),
            none: () => BorderSide.none,
          ),
        ),
      ),
      color: state.map<Color>(
        active: () => color,
        processing: () => color.withValues(alpha: 0.5),
        inactive: () => color.withValues(alpha: 0.5),
      ),
      child: CustomPaint(
        painter:
            borderStatusPainter ??
            BorderStatusPainter(
              borderStatus: borderStatus,
              icon: borderStatus.maybeMapOrNull<IconData>(error: () => Icons.error, success: () => Icons.check_circle),
              color: borderStatus.map<Color>(
                error: () => Theme.of(context).appColors.error,
                success: () => Theme.of(context).appColors.success,
                none: () => Theme.of(context).appColors.divider,
              ),
            ),
        child: Opacity(
          opacity: state.maybeMap<double>(active: () => 1, orElse: () => 0.4),
          child: Padding(padding: padding, child: child),
        ),
      ),
    ),
  );
}

class BorderStatusPainter extends CustomPainter {
  const BorderStatusPainter({required this.borderStatus, required this.icon, required this.color});

  final BorderStatus borderStatus;
  final IconData? icon;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (icon == null) return;

    TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: String.fromCharCode(icon!.codePoint),
          style: TextStyle(
            color: color,
            fontFamily: icon!.fontFamily,
            fontWeight: FontWeight.w400,
            fontSize: 14,
            height: 1,
          ),
        ),
      )
      ..layout()
      ..paint(canvas, Offset(size.width - 20, 6));
  }

  @override
  bool shouldRepaint(covariant BorderStatusPainter oldDelegate) =>
      oldDelegate.borderStatus != borderStatus || oldDelegate.icon != icon || oldDelegate.color != color;
}
