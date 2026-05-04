import 'package:intl/intl.dart' show DateFormat;

extension DateTimeExtension on DateTime {
  String get toGarbageUTCString => "${DateFormat('yyyy-MM-dd HH:mm:ss').format(toUtc())} UTC";

  String get dateTime$yyyyMMddHHmmss => DateFormat('yyyy-MM-dd HH:mm:ss').format(this);
}
