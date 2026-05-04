import 'package:ui/ui.dart';

import 'button/app_buttons.dart';
import 'theme/app_colors.dart';
import 'theme/text_style.dart';

/// {@template home_screen}
/// HomeScreen widget.
/// {@endtemplate}
class HomeScreen extends StatefulWidget {
  /// {@macro home_screen}
  const HomeScreen({
    super.key, // ignore: unused_element
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// State for widget HomeScreen.
class _HomeScreenState extends State<HomeScreen> {
  late final DutyDataState dutyData;
  late final DutyDataState ssbData;

  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();

    dutyData = DutyDataState(title: 'Break', seconds: 130, isRunning: true);
    ssbData = DutyDataState(title: 'SSB', seconds: 260, isRunning: true);
  }

  @override
  void dispose() {
    dutyData.dispose();

    super.dispose();
  }
  /* #endregion */

  @override
  Widget build(BuildContext context) => Scaffold(
    // backgroundColor: Theme.of(context).appColors.black,
    body: ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const TextStyleUI(),

        const SectionWidget(
          title: 'AppColorsUI',
          children: [Center(child: SizedBox(width: 400, child: AppColorsUI()))],
        ),

        SectionWidget(
          title: 'AppTextField',
          children: [
            SizedBox(
              width: 400,
              child: Column(
                spacing: 16,
                children: [
                  AppTextField(
                    controller: TextEditingController(),
                    title: 'Email',
                    validator: (value) => value?.isNotEmpty == true ? null : 'Email is required',
                    onFieldSubmitted: print,
                    errorText: null,
                  ),
                  AppTextField(
                    controller: TextEditingController(),
                    title: 'Email',
                    validator: (value) => value?.isNotEmpty == true ? null : 'Email is required',
                    onFieldSubmitted: print,
                    errorText: 'Email is required',
                  ),
                ],
              ),
            ),
          ],
        ),

        const SectionWidget(
          title: 'AppButtons',
          children: [SizedBox(width: 400, child: AppButtons())],
        ),

        SectionWidget(
          title: 'DutyStatusCircle',
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Card(
                color: Theme.of(context).appColors.surface,
                child: Center(
                  child: SizedBox.square(
                    dimension: 100,
                    child: Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                        DutyStatusCircle(color: Theme.of(context).appColors.breakC, dutyData: dutyData),
                        Align(
                          alignment: Alignment.topRight,
                          child: DutyStatusCircleMini(color: Theme.of(context).appColors.breakC, dutyData: dutyData),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        SectionWidget(
          title: 'DutyStatusCircle Dark',
          children: [
            SizedBox(
              height: 200,
              child: Theme(
                data: AppThemeData.dark(),
                child: Card(
                  color: AppThemeData.dark().appColors.surface,
                  child: Center(
                    child: SizedBox.square(
                      dimension: 100,
                      child: Stack(
                        fit: StackFit.expand,
                        alignment: Alignment.center,
                        children: [
                          DutyStatusCircle(color: AppThemeData.dark().appColors.breakC, dutyData: dutyData),
                          Align(
                            alignment: Alignment.topRight,
                            child: DutyStatusCircleMini(
                              color: AppThemeData.dark().appColors.breakC,
                              dutyData: dutyData,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        Theme(
          data: AppThemeData.dark(),
          child: Card(
            color: AppThemeData.dark().appColors.surface,
            child: DutyStatusCircle(color: Theme.of(context).appColors.breakC, dutyData: dutyData),
          ),
        ),

        SectionWidget(
          title: 'Log Sheet',
          children: [
            Card(
              color: AppThemeData.light().appColors.surface,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: LogSheet(
                  logTableTitles: (status: 'Status', startTime: 'Start Time', location: 'Location', action: ''),
                  onLogTapped: print,
                  logDate: DateTime.now(),
                  logDatas: const [],
                  violations: const [],
                ),
              ),
            ),
          ],
        ),

        SectionWidget(
          title: 'Log Sheet Dark',
          children: [
            Theme(
              data: AppThemeData.dark(),
              child: Card(
                color: AppThemeData.dark().appColors.surface,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: LogSheet(
                    logTableTitles: (status: 'Status', startTime: 'Start Time', location: 'Location', action: ''),
                    onLogTapped: print,
                    logDate: DateTime.now(),
                    logDatas: const [],
                    violations: const [],
                  ),
                ),
              ),
            ),
          ],
        ),

        SectionWidget(
          title: 'PinCode',
          children: [
            SizedBox(
              width: 400,
              child: PinCode(
                controller: TextEditingController(),
                focusNode: FocusNode(),
                length: 4,
                onChanged: print,
                enabled: true,
              ),
            ),
          ],
        ),

        SectionWidget(
          title: 'DutyActiveCircle',
          children: [
            SizedBox(
              height: 300,
              width: 327,
              child: Theme(
                data: AppThemeData.dark(),
                child: Card(
                  color: AppThemeData.dark().appColors.surface,
                  child: GridPaper(
                    interval: 20,
                    color: Colors.white.withValues(alpha: 0.2),
                    child: DutyActiveCircle(
                      color: AppThemeData.dark().appColors.driveC,
                      ssbColor: AppThemeData.dark().appColors.tertiary,
                      dutyData: dutyData,
                      // ssbData: ssbData,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ].expand((widget) => [widget, const SizedBox(height: 32)]).toList(),
    ),
  );
}

class SectionWidget extends StatelessWidget {
  const SectionWidget({required this.children, required this.title, this.padding, super.key});

  final String title;
  final List<Widget> children;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) => Center(
    child: DecoratedBox(
      decoration: ShapeDecoration(
        shape: SmoothRectangleBorders(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: Theme.of(context).appColors.divider),
        ),
        color: Theme.of(context).appColors.buttonBorder,
      ),
      child: Column(
        children: [
          // Widget title
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Theme.of(context).appColors.divider)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Center(child: AppText.w500s16(title)),
            ),
          ),

          // Children
          Padding(
            padding: padding ?? const EdgeInsets.all(8),
            child: Column(spacing: 8, children: children),
          ),
        ],
      ),
    ),
  );
}
