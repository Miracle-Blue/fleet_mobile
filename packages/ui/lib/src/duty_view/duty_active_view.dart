import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../animation/animated_flip_counter.dart';
import '../border/smooth_rectangle_border.dart';
import '../theme/text.dart';
import '../theme/theme.dart';
import 'duty_data_state.dart';

/// {@template duty_active_view}
/// DutyActiveView widget.
/// {@endtemplate}
class DutyActiveView extends StatelessWidget {
  /// {@macro duty_active_view}
  const DutyActiveView({
    required this.dutyData,
    required this.ssbColor,
    required this.color,
    this.ssbData,
    this.width = 260,
    super.key, // ignore: unused_element
  });

  final DutyDataState dutyData;
  final DutyDataState? ssbData;
  final Color ssbColor;
  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: ShapeDecoration(
      color: Theme.of(context).appColors.secondary,
      shape: SmoothRectangleBorders(borderRadius: BorderRadius.circular(16), smoothness: .7),
    ),
    child: SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: ListenableBuilder(
          listenable: Listenable.merge([dutyData, ssbData]),
          builder: (context, _) {
            final seconds = dutyData.seconds;
            final ssbSeconds = ssbData?.seconds ?? 0;

            return TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              tween: Tween(end: ssbSeconds == 0 ? 0 : (ssbSeconds / (ssbData?.initialSeconds ?? 1)).clamp(0, 1)),
              builder: (context, ssbProgress, _) => TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 300),
                tween: Tween(end: seconds == 0 ? 0 : (seconds / dutyData.initialSeconds).clamp(0, 1)),
                builder: (context, progress, _) => ssbData == null
                    ? _ActiveView(
                        dutyData: dutyData,
                        color: color,
                        seconds: seconds,
                        width: width,
                        ssbColor: ssbColor,
                        ssbProgress: ssbProgress,
                        progress: progress,
                      )
                    : _SSBActiveView(
                        dutyData: dutyData,
                        ssbData: ssbData!,
                        color: color,
                        seconds: seconds,
                        ssbSeconds: ssbSeconds,
                        width: width,
                        ssbColor: ssbColor,
                        ssbProgress: ssbProgress,
                        progress: progress,
                      ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

/// {@template duty_active_view}
/// _SSBActiveView widget.
/// {@endtemplate}
class _SSBActiveView extends StatelessWidget {
  /// {@macro duty_active_view}
  const _SSBActiveView({
    required this.dutyData,
    required this.ssbData,
    required this.color,
    required this.seconds,
    required this.ssbSeconds,
    required this.width,
    required this.ssbColor,
    required this.ssbProgress,
    required this.progress,
  });

  final DutyDataState dutyData;
  final DutyDataState ssbData;
  final Color color;
  final int seconds;
  final int ssbSeconds;
  final double width;
  final Color ssbColor;
  final double ssbProgress;
  final double progress;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        children: [
          AppText.w500s14(dutyData.title, color: color, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(width: 4),
          // Hours
          AnimatedFlipCounter(
            value: (seconds ~/ 3600).clamp(0, 999),
            wholeDigits: 2,
            textStyle: AppTypography.byDefault.w500s14.copyWith(
              color: Theme.of(context).appColors.text,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            ':',
            style: AppTypography.byDefault.w500s14.copyWith(
              color: Theme.of(context).appColors.text,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),

          // Minutes
          AnimatedFlipCounter(
            value: (seconds ~/ 60) % 60,
            wholeDigits: 2,
            textStyle: AppTypography.byDefault.w500s14.copyWith(
              color: Theme.of(context).appColors.text,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppText(
            ssbData.title,
            AppTypography.byDefault.w700s16.copyWith(fontSize: 28, height: 1.2),
            color: ssbColor,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Row(
              children: [
                // Hours
                AnimatedFlipCounter(
                  value: (ssbSeconds ~/ 3600).clamp(0, 999),
                  wholeDigits: 2,
                  textStyle: AppTypography.byDefault.w700s16.copyWith(
                    color: Theme.of(context).appColors.text,
                    fontSize: 28,
                    height: 1.2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  ':',
                  style: AppTypography.byDefault.w700s16.copyWith(
                    color: Theme.of(context).appColors.text,
                    fontSize: 28,
                    height: 1.2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),

                // Minutes
                AnimatedFlipCounter(
                  value: (ssbSeconds ~/ 60) % 60,
                  wholeDigits: 2,
                  textStyle: AppTypography.byDefault.w700s16.copyWith(
                    color: Theme.of(context).appColors.text,
                    fontSize: 28,
                    height: 1.2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      const SizedBox(height: 8),

      SizedBox(
        width: width,
        height: 12,
        child: CustomPaint(
          painter: LinearPainter(
            activeColor: color,
            inactiveColor: Theme.of(context).appColors.gray.withValues(alpha: 0.5),
            ssbColor: ssbColor,
            ssbProgress: ssbProgress,
            progress: progress,
          ),
        ),
      ),
    ],
  );
}

/// {@template duty_active_view}
/// ActiveView widget.
/// {@endtemplate}
class _ActiveView extends StatelessWidget {
  /// {@macro active_view}
  const _ActiveView({
    required this.dutyData,
    required this.color,
    required this.seconds,
    required this.width,
    required this.ssbColor,
    required this.ssbProgress,
    required this.progress,
  });

  final DutyDataState dutyData;
  final Color color;
  final int seconds;
  final double width;
  final Color ssbColor;
  final double ssbProgress;
  final double progress;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      AppText.w500s14(dutyData.title, color: color, maxLines: 1, overflow: TextOverflow.ellipsis),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Hours
          AnimatedFlipCounter(
            value: (seconds ~/ 3600).clamp(0, 999),
            wholeDigits: 2,
            textStyle: AppTypography.byDefault.w700s16.copyWith(
              color: Theme.of(context).appColors.text,
              fontSize: 28,
              height: 1.2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            ':',
            style: AppTypography.byDefault.w700s16.copyWith(
              color: Theme.of(context).appColors.text,
              fontSize: 28,
              height: 1.2,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),

          // Minutes
          AnimatedFlipCounter(
            value: (seconds ~/ 60) % 60,
            wholeDigits: 2,
            textStyle: AppTypography.byDefault.w700s16.copyWith(
              color: Theme.of(context).appColors.text,
              fontSize: 28,
              height: 1.2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),

      const SizedBox(height: 8),

      SizedBox(
        width: width,
        height: 12,
        child: CustomPaint(
          painter: LinearPainter(
            activeColor: color,
            inactiveColor: Theme.of(context).appColors.gray.withValues(alpha: 0.5),
            ssbColor: ssbColor,
            ssbProgress: ssbProgress,
            progress: progress,
          ),
        ),
      ),
    ],
  );
}

class LinearPainter extends CustomPainter {
  const LinearPainter({
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
    const gap = 2.0;
    const minFraction = 0.001;

    final barHeight = strokeWidth;
    final top = (size.height - barHeight) / 2;
    final radius = Radius.circular(barHeight / 2.5);

    final clampedProgress = progress.clamp(0.0, 1.0);
    final clampedSsb = ssbProgress.clamp(0.0, 1.0);

    if (clampedProgress <= minFraction && clampedSsb <= minFraction) {
      final paint = Paint()..color = inactiveColor;
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, top, size.width, barHeight), radius), paint);
      return;
    }

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

    final availableWidth = size.width - gap * gapCount;

    final basePaint = Paint()..color = isDriverHigher ? ssbColor : activeColor;
    final tipPaint = Paint()..color = isDriverHigher ? activeColor : ssbColor;
    final inactivePaint = Paint()..color = inactiveColor;

    var x = 0.0;

    if (hasBase) {
      final w = availableWidth * baseFraction;
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x, top, w, barHeight), radius), basePaint);
      x += w;
      if (hasTip || hasInactive) x += gap;
    }

    if (hasTip) {
      final w = availableWidth * tipFraction;
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x, top, w, barHeight), radius), tipPaint);
      x += w;
      if (hasInactive) x += gap;
    }

    if (hasInactive) {
      final w = availableWidth * inactiveFraction;
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x, top, w, barHeight), radius), inactivePaint);
    }
  }

  @override
  bool shouldRepaint(covariant LinearPainter oldDelegate) =>
      activeColor != oldDelegate.activeColor ||
      inactiveColor != oldDelegate.inactiveColor ||
      ssbColor != oldDelegate.ssbColor ||
      ssbProgress != oldDelegate.ssbProgress ||
      progress != oldDelegate.progress ||
      strokeWidth != oldDelegate.strokeWidth;
}
