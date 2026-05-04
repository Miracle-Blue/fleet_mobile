import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../animation/animated_flip_counter.dart';
import '../theme/text.dart';
import '../theme/theme.dart';
import 'duty_data_state.dart';

/// {@template duty_status_circle}
/// DutyStatusCircle widget.
/// {@endtemplate}
class DutyStatusCircle extends StatelessWidget {
  /// {@macro duty_status_circle}
  const DutyStatusCircle({
    required this.dutyData,
    required this.color,
    this.radius = 96,
    this.strokeWidth = 4,
    super.key, // ignore: unused_element
  });

  final DutyDataState dutyData;
  final double radius;
  final double strokeWidth;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8),
    child: Center(
      child: SizedBox.square(
        dimension: radius,
        child: ListenableBuilder(
          listenable: dutyData,
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: color, blurRadius: 40, spreadRadius: 15, offset: Offset.zero)],
              ),
              child: const SizedBox.shrink(),
            ),
          ),
          builder: (context, child) {
            final seconds = dutyData.seconds;

            return TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              tween: Tween(end: seconds == 0 ? 0 : (seconds / dutyData.initialSeconds).clamp(0, 1)),
              builder: (context, progress, _) => CustomPaint(
                size: Size.square(radius),
                painter: DutyStatusCirclePainter(
                  progress: progress,
                  activeColor: color,
                  bgColor: Theme.of(context).appColors.surface,
                  inactiveColor: Theme.of(context).appColors.divider,
                  strokeWidth: strokeWidth,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    ?child,
                    Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Hours
                              AnimatedFlipCounter(
                                value: (seconds ~/ 3600).clamp(0, 999),
                                wholeDigits: 2,
                                textStyle: AppTypography.byDefault.w700s16.copyWith(
                                  color: Theme.of(context).appColors.text,
                                  fontSize: 20,
                                  height: 1.2,
                                ),
                              ),
                              Text(
                                ':',
                                style: AppTypography.byDefault.w700s16.copyWith(
                                  color: Theme.of(context).appColors.text,
                                  fontSize: 20,
                                  height: 1.2,
                                ),
                              ),

                              // Minutes
                              AnimatedFlipCounter(
                                value: (seconds ~/ 60) % 60,
                                wholeDigits: 2,
                                textStyle: AppTypography.byDefault.w700s16.copyWith(
                                  color: Theme.of(context).appColors.text,
                                  fontSize: 20,
                                  height: 1.2,
                                ),
                              ),

                              // Seconds
                              if (seconds % 60 != 0 && dutyData.isTimerRunning && dutyData.showSeconds)
                                AnimatedFlipCounter(
                                  value: seconds % 60,
                                  wholeDigits: 2,
                                  padding: const EdgeInsets.only(top: 2),
                                  textStyle: AppTypography.byDefault.w500s16.copyWith(
                                    color: Theme.of(context).appColors.text,
                                    fontSize: 11,
                                    height: 1.2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                          ),
                          AppText(
                            dutyData.title,
                            AppTypography.byDefault.w500s14.copyWith(height: 1),
                            color: color.withValues(alpha: 0.7),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

class DutyStatusCirclePainter extends CustomPainter {
  const DutyStatusCirclePainter({
    required this.activeColor,
    required this.inactiveColor,
    required this.bgColor,
    required this.progress,
    this.strokeWidth = 4,
  });

  final Color activeColor;
  final Color inactiveColor;
  final Color bgColor;
  final double progress;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final delta = progress != 0 ? -math.pi / 24 : 0;
    final radius = math.min(size.width / 2, size.height / 2);

    final bgPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill;

    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final inactivePaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    canvas
      ..drawCircle(Offset(size.width / 2, size.height / 2), radius - strokeWidth / 2, bgPaint)
      ..drawArc(
        Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: radius * 2, height: radius * 2),
        -math.pi / 2 + delta,
        -2 * math.pi * (1 - progress) - 2 * delta,
        false,
        inactivePaint,
      )
      ..drawArc(
        Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: radius * 2, height: radius * 2),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        activePaint,
      );
  }

  @override
  bool shouldRepaint(covariant DutyStatusCirclePainter oldDelegate) =>
      activeColor != oldDelegate.activeColor ||
      inactiveColor != oldDelegate.inactiveColor ||
      bgColor != oldDelegate.bgColor ||
      progress != oldDelegate.progress ||
      strokeWidth != oldDelegate.strokeWidth;
}
