import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../animation/animated_flip_counter.dart';
import '../border/smooth_rectangle_border.dart';
import '../duty_view/duty_data_state.dart';
import '../service/haptics_service.dart';
import '../theme/theme.dart';
import 'button_state.dart';

/// {@template button_duty}
/// ButtonDuty widget.
/// {@endtemplate}
class ButtonDuty extends StatelessWidget {
  /// {@macro button_duty}
  const ButtonDuty({
    required this.child,
    required this.onPressed,
    this.feedback = HapticsService.selectionClick,
    this.dutyData,
    this.color = const Color(0xFFFFFFFF),
    this.state = ButtonState.inactive,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    super.key, // ignore: unused_element
  });

  final Color color;
  final Widget child;
  final ButtonState state;
  final EdgeInsets padding;
  final VoidCallback? feedback;
  final DutyDataState? dutyData;
  final BorderRadius borderRadius;
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
      shape: SmoothRectangleBorders(smoothness: .7, borderRadius: borderRadius),
      color: switch (dutyData) {
        null => Theme.of(context).appColors.secondary,
        _ => state.map<Color>(
          active: () => color,
          processing: () => color.withValues(alpha: 0.5),
          inactive: () => color.withValues(alpha: 0.5),
        ),
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: switch (dutyData) {
          null => Opacity(
            key: const ValueKey('empty_duty_data'),
            opacity: state.maybeMap<double>(active: () => 1, orElse: () => 0.4),
            child: Padding(padding: padding, child: child),
          ),
          DutyDataState e => Opacity(
            key: const ValueKey('duty_data'),
            opacity: state.maybeMap<double>(active: () => 1, orElse: () => 0.3),
            child: Theme(
              data: AppThemeData.dark(),
              child: ColoredBox(
                color: Colors.black26.withValues(alpha: .1),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ColoredBox(
                        color: color,
                        child: Padding(padding: padding, child: child),
                      ),
                    ),
                    IntrinsicWidth(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                        child: ListenableBuilder(
                          listenable: e,
                          builder: (context, child) => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Hours
                              AnimatedFlipCounter(
                                value: (e.seconds ~/ 3600).clamp(0, 999),
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
                                value: (e.seconds ~/ 60) % 60,
                                wholeDigits: 2,
                                textStyle: AppTypography.byDefault.w700s16.copyWith(
                                  color: Theme.of(context).appColors.text,
                                  fontSize: 20,
                                  height: 1.2,
                                ),
                              ),

                              // Seconds
                              if (e.showSeconds)
                                AnimatedFlipCounter(
                                  value: e.seconds % 60,
                                  wholeDigits: 2,
                                  padding: const EdgeInsets.only(top: 2),
                                  textStyle: AppTypography.byDefault.w500s16.copyWith(
                                    color: Theme.of(context).appColors.text,
                                    fontSize: 11,
                                    height: 1.2,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        },
      ),
    ),
  );
}
