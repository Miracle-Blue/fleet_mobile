import 'dart:ui' show PointMode;

import 'package:flutter/material.dart';

import '../gen/fonts.gen.dart';
import 'log_data.dart';
import 'logs_type.dart';

class LogSheetPainter extends CustomPainter {
  const LogSheetPainter({
    required this.logDatas,
    required this.logDate,
    required this.sheetLineColor,
    required this.logLineColor,
  });

  final List<LogData> logDatas;
  final DateTime logDate;
  final Color sheetLineColor;
  final Color logLineColor;

  @override
  void paint(Canvas canvas, Size size) {
    // canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = Colors.yellow);

    // paddings x(horizontal) and y(vertical)
    const pX = 24.0;
    const pY = 20.0;

    final xNormal = (size.width - 2 * pX) / 24;
    final yNormal = (size.height - 2 * pY) / 4;

    /// * Draw sheet lines *
    final sheetLinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .4
      ..color = sheetLineColor;
    final points = <Offset>[];
    for (var i = 0; i < 25; i++) {
      final x = i * xNormal;
      points.addAll([Offset(x + pX, pY), Offset(x + pX, size.height - pY)]);
    }
    for (var i = 0; i < 5; i++) {
      final y = i * yNormal;
      points.addAll([Offset(pX, y + pY), Offset(size.width - pX, y + pY)]);
    }
    for (var i = 0; i < 4; i++) {
      for (var j = 0; j < 24; j++) {
        final x = j * xNormal;
        final y = i * yNormal;
        points.addAll([
          // top tips
          if (i == 0) ...[Offset(x + pX, y - 4 + pY), Offset(x + pX, y + pY)],

          // mini tip
          Offset(x + xNormal * .25 + pX, y + yNormal * .75 + pY),
          Offset(x + xNormal * .25 + pX, y + yNormal + pY),

          // middle tips
          Offset(x + xNormal * .50 + pX, y + yNormal * .50 + pY),
          Offset(x + xNormal * .50 + pX, y + yNormal + pY),

          // mini tip
          Offset(x + xNormal * .75 + pX, y + yNormal * .75 + pY),
          Offset(x + xNormal * .75 + pX, y + yNormal + pY),

          // xx mini tips
          for (var k = 1; k < 20; k++, (k % 5 == 0 ? k++ : null)) ...[
            Offset(x + xNormal * .05 * k + pX, y + yNormal * .875 + pY),
            Offset(x + xNormal * .05 * k + pX, y + yNormal + pY),
          ],
        ]);
      }
    }
    // last top tip horizontal line
    points.addAll([Offset(24 * xNormal + pX, pY - 4), Offset(24 * xNormal + pX, pY)]);
    canvas.drawPoints(PointMode.lines, points, sheetLinePaint);

    /// * Draw sheet bg Color *
    for (var i = 0; i < 5; i++) {
      if (i == 4) continue;
      canvas.drawRect(
        Rect.fromLTWH(pX, i * yNormal + pY, size.width - 2 * pX, yNormal),
        Paint()..color = i.isOdd ? const Color.fromARGB(35, 35, 35, 35) : const Color.fromARGB(35, 225, 225, 225),
      );
    }

    /// * Draw sheet text *
    final sheetTextStyle = TextStyle(
      color: sheetLineColor,
      fontFamily: FontFamily.poppins,
      fontWeight: FontWeight.w500,
      fontSize: 6,
      height: 1.2,
    );
    for (var i = 0; i < 25; i++) {
      final x = i * xNormal + pX;

      final textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: switch (i) {
            0 || 24 => 'M',
            12 => 'N',
            _ => '${i % 12}',
          },
          style: switch (i) {
            0 || 24 => sheetTextStyle.copyWith(fontWeight: FontWeight.w900),
            12 => sheetTextStyle.copyWith(fontWeight: FontWeight.w900),
            _ => sheetTextStyle,
          },
        ),
      )..layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, pY - textPainter.height / 2 - 8));
    }

    for (var i = 0; i < 11; i += 2) {
      if (i == 10) continue;

      final y = (i - 1) * yNormal / 2 + pY;

      final textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: switch (i) {
            2 => 'OFF',
            4 => 'SB',
            6 => 'DR',
            8 => 'ON',
            _ => '',
          },
          style: sheetTextStyle.copyWith(fontWeight: FontWeight.w900),
        ),
      )..layout();
      textPainter.paint(canvas, Offset(pX - textPainter.width - 2, y - textPainter.height / 2));
    }

    /// * Draw log data *
    final logDataPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = logLineColor
      ..strokeWidth = 1.5;
    final logDataPoints = <Offset>[];
    for (var i = 0; i < logDatas.length; i++) {
      final logData = logDatas[i];
      if (!logData.logType.showLine) continue;

      final endTime = logData.endTime ?? DateTime.now();

      final isBeforeToday = logData.startTime.isBefore(
        logDate.copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0),
      );
      final isAfterToday = endTime.isAfter(
        logDate.copyWith(hour: 23, minute: 59, second: 59, millisecond: 0, microsecond: 0),
      );

      final xStart = isBeforeToday ? 0 : (logData.startTime.hour * 60 + logData.startTime.minute) / 1440;
      final xStartOffset = xStart * (size.width - 2 * pX) + pX;
      final xEnd = isAfterToday ? 1 : (endTime.hour * 60 + endTime.minute) / 1440;
      final xEndOffset = xEnd * (size.width - 2 * pX) + pX;

      final y = switch (logData.logType) {
        LogsType.off => 1 * yNormal / 2 + pY,
        LogsType.sb => 3 * yNormal / 2 + pY,
        LogsType.dr => 5 * yNormal / 2 + pY,
        LogsType.on => 7 * yNormal / 2 + pY,
        _ => 0,
      }.toDouble();

      if (logDataPoints.isNotEmpty) {
        logDataPoints.addAll([logDataPoints.last, Offset(xStartOffset, y)]);
      }

      logDataPoints.addAll([Offset(xStartOffset, y), Offset(xEndOffset, y)]);
    }
    canvas.drawPoints(PointMode.lines, logDataPoints, logDataPaint);
  }

  @override
  bool shouldRepaint(covariant LogSheetPainter oldDelegate) => true;
}

extension on LogsType {
  bool get showLine => this == LogsType.off || this == LogsType.sb || this == LogsType.dr || this == LogsType.on;
}
