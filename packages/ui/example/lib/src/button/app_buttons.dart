import 'package:ui/ui.dart';

/// {@template app_buttons}
/// AppButtons widget.
/// {@endtemplate}
class AppButtons extends StatelessWidget {
  /// {@macro app_buttons}
  const AppButtons({
    super.key, // ignore: unused_element
  });

  /* #endregion */
  @override
  Widget build(BuildContext context) => Column(
    spacing: 8,
    mainAxisSize: MainAxisSize.min,
    children: [
      ButtonFill(
        onPressed: () {},
        state: ButtonState.inactive,
        child: AppText.w500s14(
          'Show Notification',
          color: Theme.of(context).appColors.white,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      ButtonFill(
        onPressed: () {},
        state: ButtonState.processing,
        child: AppText.w500s14(
          'Show Notification',
          color: Theme.of(context).appColors.white,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      ButtonFill(
        onPressed: () {},
        state: ButtonState.active,
        child: AppText.w500s14(
          'Show Notification',
          color: Theme.of(context).appColors.white,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      const SizedBox(height: 16),
      ButtonTiny(
        onPressed: () {},
        state: ButtonState.inactive,
        child: SizedBox.square(
          dimension: 48,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.notifications, color: Theme.of(context).appColors.white),
              AppText.w500s14('Show', color: Theme.of(context).appColors.white),
            ],
          ),
        ),
      ),
      ButtonTiny(
        onPressed: () {},
        state: ButtonState.processing,
        child: SizedBox.square(
          dimension: 48,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.notifications, color: Theme.of(context).appColors.white),
              AppText.w500s14('Show', color: Theme.of(context).appColors.white),
            ],
          ),
        ),
      ),
      ButtonTiny(
        onPressed: () {},
        state: ButtonState.active,
        child: SizedBox.square(
          dimension: 48,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.notifications, color: Theme.of(context).appColors.white),
              AppText.w500s14('Show', color: Theme.of(context).appColors.white),
            ],
          ),
        ),
      ),
      ButtonTiny(
        onPressed: () {},
        state: ButtonState.active,
        borderStatus: BorderStatus.error,
        child: SizedBox.square(
          dimension: 48,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.notifications, color: Theme.of(context).appColors.white),
              AppText.w500s14('Show', color: Theme.of(context).appColors.white),
            ],
          ),
        ),
      ),
      ButtonTiny(
        onPressed: () {},
        state: ButtonState.active,
        borderStatus: BorderStatus.success,
        child: SizedBox.square(
          dimension: 48,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.notifications, color: Theme.of(context).appColors.white),
              AppText.w500s14('Show', color: Theme.of(context).appColors.white),
            ],
          ),
        ),
      ),

      SizedBox(
        height: 130,
        child: ButtonDuty(
          onPressed: () {},
          color: Theme.of(context).appColors.breakC,
          state: ButtonState.active,
          dutyData: DutyDataState(title: 'Duty', seconds: 1000, showSeconds: true, isRunning: true),
          child: SizedBox(
            width: 100,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.bed, size: 32, color: Theme.of(context).appColors.white),
                AppText.w500s14('Sleep', color: Theme.of(context).appColors.white),
              ],
            ),
          ),
        ),
      ),

      SizedBox(
        height: 130,
        child: ButtonDuty(
          onPressed: () {},
          color: Theme.of(context).appColors.breakC,
          state: ButtonState.processing,
          dutyData: DutyDataState(title: 'Duty', seconds: 1000, showSeconds: true),
          child: SizedBox(
            width: 100,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.bed, size: 32, color: Theme.of(context).appColors.white),
                AppText.w500s14('Sleep', color: Theme.of(context).appColors.white),
              ],
            ),
          ),
        ),
      ),

      SizedBox(
        height: 130,
        child: ButtonDuty(
          onPressed: () {},
          color: Theme.of(context).appColors.breakC,
          state: ButtonState.active,
          child: SizedBox(
            width: 100,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.bed, size: 32, color: Theme.of(context).appColors.text),
                AppText.w500s14('Sleep'),
              ],
            ),
          ),
        ),
      ),

      AdaptiveBackButton(onTap: () {}),
    ],
  );
}
