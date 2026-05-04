import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logbook/logbook.dart';
import 'package:platform_info/platform_info.dart';
import 'package:throttling/throttling.dart';

import '../constant/config.dart';
import '../constant/pubspec.yaml.g.dart';
import '../extension/string_extension.dart';

/// {@template telegram_bot_error_logger}
/// Telegram bot error logger
/// {@endtemplate}
final class TelegramBotErrorLogger {
  TelegramBotErrorLogger({
    required this.deviceInfo,
    required this.tempDirectoryPath,
    required this.botToken,
    required this.chatId,
  }) : _sendMessageThrottling = Throttling(duration: const Duration(seconds: 5));

  final DeviceInfo? deviceInfo;
  final String tempDirectoryPath;
  final String botToken;
  final String chatId;

  late final Throttling<void> _sendMessageThrottling;

  static const String version = '0.1.0';

  String get _generalErrorInfo {
    final now = DateTime.now();

    final platformEmoji = Platform.I.when(
      android: () => '🤖',
      iOS: () => '🍏',
      macOS: () => '🍎',
      linux: () => '🐧',
      windows: () => '🪟',
      unknown: () => '🤔',
    );

    return '''
<b>📅 TIMESTAMP DETAILS</b>
<b>Date:</b> ${DateFormat('dd.MM.yyyy').format(now)}
<b>Time:</b> ${DateFormat('HH:mm:ss').format(now)} (UTC+${now.timeZoneOffset.inHours})
<b>UTC Time:</b> ${now.toUtc().toIso8601String()}

<b>$platformEmoji DEVICE DETAILS</b>
<b>Device:</b> ${_escapeHtml(deviceInfo?.device ?? 'Unknown')}
<b>OS:</b> ${_escapeHtml(deviceInfo?.os ?? 'Unknown')}
<b>App Version:</b> ${_escapeHtml(deviceInfo?.appVersion ?? 'Unknown')}''';
  }

  void logFlutterError({
    required Object? error,
    required StackTrace stackTrace,
    Map<String, Object?>? additionalInfo,
  }) => _sendMessageThrottling.throttle(() async {
    try {
      final additionalInfoData = switch (additionalInfo) {
        Map<String, Object?> data => const JsonEncoder.withIndent('  ').convert(data),
        _ => null,
      }?.ellipsis(500);

      final fullText =
          '''
🚨 <b>ERROR REPORT</b>
#${Pubspec.name} #mobile │ <b>logger_version: $version</b>

$_generalErrorInfo
${additionalInfoData != null ? '\n<b>🔎 ADDITIONAL INFO</b>\n<pre>$additionalInfoData</pre>\n' : ''}
<b>🔎 ERROR DETAILS</b>
<pre>${_escapeHtml(error?.toString().ellipsis(100) ?? 'Unknown')}</pre>

<b>📍 Stack Trace</b>
<pre>${_escapeHtml(stackTrace.toString().ellipsis(200))}</pre>
''';

      final file = File('$tempDirectoryPath/error_${DateTime.now().millisecondsSinceEpoch}.txt');
      await file.writeAsString('$error\n$stackTrace');

      final request = http.MultipartRequest('POST', Uri.parse('${Config.telegramApiBaseUrl}/bot$botToken/sendDocument'))
        ..fields['chat_id'] = chatId
        ..fields['parse_mode'] = 'HTML'
        ..fields['caption'] = fullText
        ..files.add(await http.MultipartFile.fromPath('document', file.path));

      final response = await request.send();

      file.deleteSync();
      l.i('📤 Telegram notification sent: ${response.statusCode}');
    } on Object catch (e) {
      l.s('Error while logging FlutterError "$e" inside TelegramBotErrorLogger.logFlutterError', stackTrace);
    }
  });
  // Escape special characters for HTML
  String _escapeHtml(String text) => text
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#x27;');

  void dispose() => _sendMessageThrottling.close();
}

final class DeviceInfo {
  const DeviceInfo({required this.device, required this.os, required this.appVersion});

  final String device;
  final String os;
  final String appVersion;

  Map<String, String> toJson() => {'device': device, 'os': os, 'app_version': appVersion};
}
