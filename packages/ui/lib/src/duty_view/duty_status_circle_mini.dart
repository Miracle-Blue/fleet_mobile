import '../../ui.dart';
import '../animation/animated_flip_counter.dart';

/// {@template duty_status_circle_mini}
/// DutyStatusCircleMini widget.
/// {@endtemplate}
class DutyStatusCircleMini extends StatelessWidget {
  /// {@macro duty_status_circle_mini}
  const DutyStatusCircleMini({
    required this.dutyData,
    required this.color,
    this.radius = 40,
    super.key, // ignore: unused_element
  });

  final DutyDataState dutyData;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: radius,
    child: ListenableBuilder(
      listenable: dutyData,
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: color, blurRadius: 20, spreadRadius: 5, offset: Offset.zero)],
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
              activeColor: color,
              inactiveColor: Theme.of(context).appColors.divider,
              strokeWidth: 2.5,
              progress: progress,
              bgColor: Theme.of(context).appColors.surface,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
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
                              fontSize: 10,
                              height: 1.2,
                            ),
                          ),
                          Text(
                            ':',
                            style: AppTypography.byDefault.w700s16.copyWith(
                              color: Theme.of(context).appColors.text,
                              fontSize: 10,
                              height: 1.2,
                            ),
                          ),

                          // Minutes
                          AnimatedFlipCounter(
                            value: (seconds ~/ 60) % 60,
                            wholeDigits: 2,
                            textStyle: AppTypography.byDefault.w700s16.copyWith(
                              color: Theme.of(context).appColors.text,
                              fontSize: 10,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                      AppText(
                        'SSB',
                        AppTypography.byDefault.w400s10.copyWith(height: 1, fontSize: 9),
                        color: Theme.of(context).appColors.text.withValues(alpha: 0.5),
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
  );
}
