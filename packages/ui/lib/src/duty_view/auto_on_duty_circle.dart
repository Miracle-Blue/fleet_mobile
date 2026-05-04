import 'package:flutter/material.dart';

import '../animation/animated_flip_counter.dart';
import '../theme/text.dart';
import '../theme/theme.dart';
import 'duty_data_state.dart';
import 'duty_status_circle.dart';

/// {@template auto_on_duty_circle}
/// AutoOnDutyCircle widget.
/// {@endtemplate}
class AutoOnDutyCircle extends StatelessWidget {
  /// {@macro auto_on_duty_circle}
  const AutoOnDutyCircle({
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Minutes
                          AnimatedFlipCounter(
                            value: (seconds ~/ 60).clamp(0, 99),
                            wholeDigits: 2,
                            textStyle: AppTypography.byDefault.w700s16.copyWith(
                              color: Theme.of(context).appColors.text,
                              fontSize: 30,
                              height: 1.2,
                            ),
                          ),
                          Center(
                            child: AppText(
                              ':',
                              AppTypography.byDefault.w700s16.copyWith(
                                color: Theme.of(context).appColors.text,
                                fontSize: 30,
                                height: 1.2,
                              ),
                            ),
                          ),

                          // Seconds
                          AnimatedFlipCounter(
                            value: seconds % 60,
                            wholeDigits: 2,
                            textStyle: AppTypography.byDefault.w700s16.copyWith(
                              color: Theme.of(context).appColors.text,
                              fontSize: 30,
                              height: 1.2,
                            ),
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
