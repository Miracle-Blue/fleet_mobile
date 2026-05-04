import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../border/smooth_rectangle_border.dart';
import '../extension/int_extention.dart';
import '../theme/text.dart';
import '../theme/theme.dart';
import 'log_data.dart';
import 'log_sheet_painter.dart';
import 'logs_type.dart';
import 'violations.dart';

/// {@template log_sheet}
/// LogSheet widget.
/// {@endtemplate}
class LogSheet extends StatelessWidget {
  /// {@macro log_sheet}
  const LogSheet({
    required this.logDatas,
    required this.violations,
    required this.logDate,
    required this.logTableTitles,
    required this.onLogTapped,
    super.key, // ignore: unused_element
  });

  final List<LogData> logDatas;
  final List<Violation> violations;
  final DateTime logDate;

  final ({String status, String startTime, String location, String action}) logTableTitles;
  final void Function(LogData log) onLogTapped;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CustomPaint(
        size: Size(double.infinity, MediaQuery.sizeOf(context).longestSide * .16),
        painter: LogSheetPainter(
          logDatas: logDatas,
          logDate: logDate,
          sheetLineColor: Theme.of(context).appColors.onSecondary.withValues(alpha: .7),
          logLineColor: Theme.of(context).appColors.primary,
        ),
      ),
      LogTotalTimeView(logDatas: logDatas, logDate: logDate),

      LogViolationsView(violations: violations, logDate: logDate),

      Padding(
        padding: const EdgeInsets.all(4),
        child: DecoratedBox(
          decoration: ShapeDecoration(
            shape: SmoothRectangleBorders(borderRadius: BorderRadius.circular(12), smoothness: .7),
            color: Theme.of(context).appColors.buttonBorder,
          ),
          child: DataTable(
            clipBehavior: Clip.antiAlias,
            showCheckboxColumn: false,
            horizontalMargin: 12,
            checkboxHorizontalMargin: 0,
            columnSpacing: 0,
            headingRowHeight: 42,
            dataRowMaxHeight: 36,
            dataRowMinHeight: 28,
            dividerThickness: 0.3,
            border: TableBorder.all(
              color: Theme.of(context).appColors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            columns: [
              DataColumn(
                columnWidth: const FlexColumnWidth(.4),
                label: Expanded(
                  child: AppText(
                    logTableTitles.status,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    Theme.of(context).appTextStyles.w500s14.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              DataColumn(
                columnWidth: const FlexColumnWidth(.5),
                label: Expanded(
                  child: AppText(
                    logTableTitles.startTime,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    Theme.of(context).appTextStyles.w500s14.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              DataColumn(
                columnWidth: const FlexColumnWidth(1.2),
                label: Expanded(
                  child: AppText(
                    logTableTitles.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    Theme.of(context).appTextStyles.w500s14.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              DataColumn(
                columnWidth: const FlexColumnWidth(.1),
                label: Expanded(
                  child: AppText(
                    logTableTitles.action,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    Theme.of(context).appTextStyles.w500s14.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
            rows: logDatas
                .mapIndexed<DataRow>(
                  (i, e) => DataRow(
                    onSelectChanged: (_) => onLogTapped(e),
                    color: i.isEven
                        ? WidgetStateProperty.all(Theme.of(context).appColors.gray.withValues(alpha: .2))
                        : null,
                    cells: [
                      DataCell(
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: DecoratedBox(
                              decoration: ShapeDecoration(
                                shape: SmoothRectangleBorders(
                                  borderRadius: BorderRadius.circular(6),
                                  smoothness: .7,
                                  side: switch (e.logType) {
                                    LogsType.off ||
                                    LogsType.sb ||
                                    LogsType.dr ||
                                    LogsType.on ||
                                    LogsType.intermediate ||
                                    LogsType.intermediatePC ||
                                    LogsType.pc ||
                                    LogsType.ym => BorderSide.none,
                                    _ => BorderSide(width: 1.5, color: Theme.of(context).appColors.tealBlue),
                                  },
                                ),
                                color: switch (e.logType) {
                                  LogsType.off => Theme.of(context).appColors.gray,
                                  LogsType.sb => Theme.of(context).appColors.breakC,
                                  LogsType.dr => Theme.of(context).appColors.driveC,
                                  LogsType.on => Theme.of(context).appColors.tealBlue,
                                  LogsType.intermediate => Theme.of(context).appColors.error,
                                  LogsType.intermediatePC => Theme.of(context).appColors.error,
                                  LogsType.pc => Theme.of(context).appColors.tealBlue,
                                  LogsType.ym => Theme.of(context).appColors.tealBlue,
                                  _ => null,
                                },
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(minWidth: 30),
                                  child: AppText(
                                    switch (e.logType) {
                                      LogsType.off => 'OFF',
                                      LogsType.sb => 'SB',
                                      LogsType.dr => 'DR',
                                      LogsType.on => 'ON',
                                      LogsType.intermediate => 'INTE',
                                      LogsType.intermediatePC => 'INPC',
                                      LogsType.pc => 'PC',
                                      LogsType.ym => 'YM',
                                      LogsType.wt => 'WT',
                                      LogsType.certify => 'CERT',
                                      LogsType.powerOn => 'PON',
                                      LogsType.powerOff => 'POF',
                                      LogsType.login => 'LGN',
                                      LogsType.logout => 'LGO',
                                      LogsType.pcPowerOn => 'PCON',
                                      LogsType.pcPowerOff => 'PCOF',
                                    },
                                    Theme.of(context).appTextStyles.w500s12,
                                    textAlign: TextAlign.center,
                                    color: switch (e.logType) {
                                      LogsType.off ||
                                      LogsType.sb ||
                                      LogsType.dr ||
                                      LogsType.on ||
                                      LogsType.intermediate ||
                                      LogsType.intermediatePC ||
                                      LogsType.pc ||
                                      LogsType.ym => Theme.of(context).appColors.white,
                                      _ => Theme.of(context).appColors.text,
                                    },
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        AppText(
                          DateFormat('hh:mm:ss a').format(
                            /// If the start time is before the log date, return the log date
                            /// example: logDate: 2026-01-10 00:00:00, startTime: 2026-01-08 10:00:00
                            /// return: 2026-01-10 00:00:00
                            /// example: logDate: 2026-01-10 00:00:00, startTime: 2026-01-10 14:00:00
                            /// return: 2026-01-10 14:00:00
                            e.startTime.isBefore(
                                  logDate.copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0),
                                )
                                ? logDate.copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0)
                                : e.startTime,
                          ),
                          Theme.of(context).appTextStyles.w500s12,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            const Icon(CupertinoIcons.location_solid, size: 14),
                            const SizedBox(width: 4),
                            Expanded(
                              child: AppText(
                                e.address.location,
                                Theme.of(context).appTextStyles.w500s12,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        AppText(
                          '',
                          Theme.of(context).appTextStyles.w500s12,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    ],
  );
}

/// {@template log_sheet}
/// LogTotalTimeView widget.
/// {@endtemplate}
class LogTotalTimeView extends StatelessWidget {
  /// {@macro log_sheet}
  const LogTotalTimeView({
    required this.logDatas,
    required this.logDate,
    super.key, // ignore: unused_element
  });

  final List<LogData> logDatas;
  final DateTime logDate;

  int getStatusDuration({
    required final List<LogData> logs,
    required final LogsType status,
    required final DateTime logsDate,
  }) {
    final startOfDay = logsDate.copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
    final endOfDay = startOfDay.copyWith(hour: 23, minute: 59, second: 59, millisecond: 0, microsecond: 0);

    return logs
        .where((e) => e.logType == status)
        .map((e) {
          final tempEndTime = e.endTime ?? DateTime.now();

          final isBeforeStartOfDay = e.startTime.isBefore(startOfDay);
          final isAfterEndOfDay = tempEndTime.isAfter(endOfDay);

          final startTime = isBeforeStartOfDay ? startOfDay : e.startTime;
          final endTime = isAfterEndOfDay ? endOfDay : tempEndTime;

          return endTime.difference(startTime).inSeconds;
        })
        .fold(0, (a, b) => a + b);
  }

  @override
  Widget build(BuildContext context) {
    final offDuration = getStatusDuration(logs: logDatas, status: LogsType.off, logsDate: logDate);
    final sbDuration = getStatusDuration(logs: logDatas, status: LogsType.sb, logsDate: logDate);
    final drDuration = getStatusDuration(logs: logDatas, status: LogsType.dr, logsDate: logDate);
    final onDuration = getStatusDuration(logs: logDatas, status: LogsType.on, logsDate: logDate);

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: AppText(
                'OFF ${offDuration.fromSecondsToHHMM}',
                Theme.of(context).appTextStyles.w500s14.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
                color: Theme.of(context).appColors.gray,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: AppText(
                'SB ${sbDuration.fromSecondsToHHMM}',
                Theme.of(context).appTextStyles.w500s14.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
                color: Theme.of(context).appColors.breakC,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: AppText(
                'DR ${drDuration.fromSecondsToHHMM}',
                Theme.of(context).appTextStyles.w500s14.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
                color: Theme.of(context).appColors.driveC,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: AppText(
                'ON ${onDuration.fromSecondsToHHMM}',
                Theme.of(context).appTextStyles.w500s14.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
                color: Theme.of(context).appColors.tealBlue,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// {@template log_violations_view}
/// LogViolationsView widget.
/// {@endtemplate}
class LogViolationsView extends StatelessWidget {
  /// {@macro log_violations_view}
  const LogViolationsView({
    required this.violations,
    required this.logDate,
    super.key, // ignore: unused_element
  });

  final List<Violation> violations;
  final DateTime logDate;

  @override
  Widget build(BuildContext context) {
    final violations =
        [
              ...this.violations,
              // Violation(id: '', key: 'break_limit', logId: '', startTime: logDate, endTime: logDate),
              // Violation(id: '', key: 'driving_limit', logId: '', startTime: logDate, endTime: logDate),
              // Violation(id: '', key: 'shift_limit', logId: '', startTime: logDate, endTime: logDate),
              // Violation(id: '', key: 'cycle_limit', logId: '', startTime: logDate, endTime: logDate),
            ]
            .map(
              (e) => ViolationKey.fromValue(e.key).maybeMapOrNull(
                breakLimit: () => 'Break Limit',
                drivingLimit: () => 'Driving Limit',
                shiftLimit: () => 'Shift Limit',
                cycleLimit: () => 'Cycle Limit',
                breakLimitWarning: () => 'Break Limit Warning',
                drivingLimitWarning: () => 'Driving Limit Warning',
                shiftLimitWarning: () => 'Shift Limit Warning',
                cycleLimitWarning: () => 'Cycle Limit Warning',
              ),
            )
            .nonNulls
            .toList();

    if (violations.isEmpty) return const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: SizedBox.shrink());

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Wrap(
          spacing: 6,
          runSpacing: 4,
          runAlignment: WrapAlignment.start,
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AppText.w500s14('Violations:', color: Theme.of(context).appColors.error),
            ...violations
                .mapIndexed((i, e) => i == 0 ? [e] : ['  •  ', e])
                .expand((e) => e)
                .map((e) => AppText.w500s14(e, color: Theme.of(context).appColors.error)),
          ],
        ),
      ),
    );
  }
}
