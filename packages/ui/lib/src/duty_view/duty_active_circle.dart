import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../animation/animated_flip_counter.dart';
import '../theme/text.dart';
import '../theme/theme.dart';
import 'duty_data_state.dart';

/// {@template duty_active_circle}
/// DutyActiveCircle widget.
/// {@endtemplate}
class DutyActiveCircle extends StatelessWidget {
  /// {@macro duty_active_circle}
  const DutyActiveCircle({
    required this.dutyData,
    required this.ssbColor,
    required this.color,
    this.ssbData,
    this.radius = 260,
    super.key, // ignore: unused_element
  });

  final DutyDataState dutyData;
  final DutyDataState? ssbData;
  final Color ssbColor;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8),
    child: Center(
      child: SizedBox.square(
        dimension: radius,
        child: ListenableBuilder(
          listenable: Listenable.merge([dutyData, ssbData]),
          child: const Center(
            child: DecoratedBox(
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: SizedBox.shrink(),
            ),
          ),
          builder: (context, child) {
            final seconds = dutyData.seconds;
            final ssbSeconds = ssbData?.seconds ?? 0;

            return TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              tween: Tween(end: ssbSeconds == 0 ? 0 : (ssbSeconds / (ssbData?.initialSeconds ?? 1)).clamp(0, 1)),
              builder: (context, ssbProgress, _) => TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 300),
                tween: Tween(end: seconds == 0 ? 0 : (seconds / dutyData.initialSeconds).clamp(0, 1)),
                builder: (context, progress, _) => CustomPaint(
                  size: Size.square(radius),
                  painter: DutyActiveCirclePainter(
                    ssbProgress: ssbProgress,
                    ssbColor: ssbColor,
                    progress: progress,
                    activeColor: color,
                    inactiveColor: Theme.of(context).appColors.gray.withValues(alpha: 0.5),
                    strokeWidth: 24,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      ?child,
                      if (ssbData != null)
                        _SSBView(
                          ssbData: ssbData!,
                          ssbColor: ssbColor,
                          ssbSeconds: ssbSeconds,
                          seconds: seconds,
                          dutyData: dutyData,
                          color: color,
                        )
                      else
                        _DriveView(dutyData: dutyData, seconds: seconds, color: color),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

/// {@template ssb_view}
/// SSBView widget.
/// {@endtemplate}
class _SSBView extends StatelessWidget {
  /// {@macro ssb_view}
  const _SSBView({
    required this.ssbData,
    required this.ssbColor,
    required this.ssbSeconds,
    required this.seconds,
    required this.dutyData,
    required this.color,
  });

  final DutyDataState ssbData;
  final Color ssbColor;
  final int ssbSeconds;
  final int seconds;
  final DutyDataState dutyData;
  final Color color;

  @override
  Widget build(BuildContext context) => Positioned.fill(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              dutyData.title,
              AppTypography.byDefault.w400s14.copyWith(height: 1),
              color: color.withValues(alpha: 0.7),
            ),

            const SizedBox(width: 4),

            // Hours
            AnimatedFlipCounter(
              value: (seconds ~/ 3600).clamp(0, 999),
              wholeDigits: 2,
              textStyle: AppTypography.byDefault.w400s14.copyWith(color: Theme.of(context).appColors.text, height: 1),
            ),
            Text(
              ':',
              style: AppTypography.byDefault.w400s14.copyWith(color: Theme.of(context).appColors.text, height: 1),
            ),

            // Minutes
            AnimatedFlipCounter(
              value: (seconds ~/ 60) % 60,
              wholeDigits: 2,
              textStyle: AppTypography.byDefault.w400s14.copyWith(color: Theme.of(context).appColors.text, height: 1),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hours
            AnimatedFlipCounter(
              value: (ssbSeconds ~/ 3600).clamp(0, 999),
              wholeDigits: 2,
              textStyle: AppTypography.byDefault.w700s28.copyWith(
                color: Theme.of(context).appColors.text,
                fontSize: 36,
                height: 1.2,
              ),
            ),
            Text(
              ':',
              style: AppTypography.byDefault.w700s28.copyWith(
                color: Theme.of(context).appColors.text,
                fontSize: 36,
                height: 1.2,
              ),
            ),

            // Minutes
            AnimatedFlipCounter(
              value: (ssbSeconds ~/ 60) % 60,
              wholeDigits: 2,
              textStyle: AppTypography.byDefault.w700s28.copyWith(
                color: Theme.of(context).appColors.text,
                fontSize: 36,
                height: 1.2,
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

        AppText(
          ssbData.title,
          AppTypography.byDefault.w500s14.copyWith(height: 1, fontSize: 18),
          color: ssbColor.withValues(alpha: 0.7),
        ),
      ],
    ),
  );
}

/// {@template duty_active_circle}
/// DriveView widget.
/// {@endtemplate}
class _DriveView extends StatelessWidget {
  /// {@macro duty_active_circle}
  const _DriveView({required this.dutyData, required this.seconds, required this.color});

  final DutyDataState dutyData;
  final int seconds;
  final Color color;

  @override
  Widget build(BuildContext context) => Positioned.fill(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hours
            AnimatedFlipCounter(
              value: (seconds ~/ 3600).clamp(0, 999),
              wholeDigits: 2,
              textStyle: AppTypography.byDefault.w700s28.copyWith(
                color: Theme.of(context).appColors.text,
                fontSize: 36,
                height: 1.2,
              ),
            ),
            Text(
              ':',
              style: AppTypography.byDefault.w700s28.copyWith(
                color: Theme.of(context).appColors.text,
                fontSize: 36,
                height: 1.2,
              ),
            ),

            // Minutes
            AnimatedFlipCounter(
              value: (seconds ~/ 60) % 60,
              wholeDigits: 2,
              textStyle: AppTypography.byDefault.w700s28.copyWith(
                color: Theme.of(context).appColors.text,
                fontSize: 36,
                height: 1.2,
              ),
            ),
          ],
        ),

        AppText(
          dutyData.title,
          AppTypography.byDefault.w500s14.copyWith(height: 1, fontSize: 18),
          color: color.withValues(alpha: 0.7),
        ),
      ],
    ),
  );
}

class DutyActiveCirclePainter extends CustomPainter {
  const DutyActiveCirclePainter({
    required this.activeColor,
    required this.inactiveColor,
    required this.ssbColor,
    required this.ssbProgress,
    required this.progress,
    this.strokeWidth = 12,
  });

  final Color activeColor;
  final Color inactiveColor;
  final Color ssbColor;
  final double ssbProgress;
  final double progress;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    const totalSweep = math.pi * 1.5;
    const startAngle = math.pi * 0.75;
    const delta = math.pi / 28;
    const minFraction = 0.001;

    final radius = math.min(size.width / 2, size.height / 2);
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCenter(center: center, width: radius * 2 - strokeWidth, height: radius * 2 - strokeWidth);

    final clampedProgress = progress.clamp(0.0, 1.0);
    final clampedSsb = ssbProgress.clamp(0.0, 1.0);
    final isDriverHigher = clampedProgress >= clampedSsb;
    final baseFraction = math.min(clampedProgress, clampedSsb);
    final tipFraction = (clampedProgress - clampedSsb).abs();
    final inactiveFraction = (1.0 - baseFraction - tipFraction).clamp(0.0, 1.0);

    final hasBase = baseFraction > minFraction;
    final hasTip = tipFraction > minFraction;
    final hasInactive = inactiveFraction > minFraction;

    var gapCount = 0;
    if (hasBase && hasTip) gapCount++;
    if (hasTip && hasInactive) gapCount++;
    if (!hasTip && hasBase && hasInactive) gapCount++;

    final availableSweep = totalSweep - delta * gapCount;

    final basePaint = Paint()
      ..color = isDriverHigher ? ssbColor : activeColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final tipPaint = Paint()
      ..color = isDriverHigher ? activeColor : ssbColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final inactivePaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    var angle = startAngle;

    if (hasBase) {
      final sweep = availableSweep * baseFraction;
      canvas.drawArc(rect, angle, sweep, false, basePaint);
      angle += sweep;
      if (hasTip || hasInactive) angle += delta;
    }

    if (hasTip) {
      final sweep = availableSweep * tipFraction;
      canvas.drawArc(rect, angle, sweep, false, tipPaint);
      angle += sweep;
      if (hasInactive) angle += delta;
    }

    if (hasInactive) {
      final sweep = availableSweep * inactiveFraction;
      canvas.drawArc(rect, angle, sweep, false, inactivePaint);
    }
  }

  @override
  bool shouldRepaint(covariant DutyActiveCirclePainter oldDelegate) =>
      activeColor != oldDelegate.activeColor ||
      inactiveColor != oldDelegate.inactiveColor ||
      ssbColor != oldDelegate.ssbColor ||
      ssbProgress != oldDelegate.ssbProgress ||
      progress != oldDelegate.progress ||
      strokeWidth != oldDelegate.strokeWidth;
}
