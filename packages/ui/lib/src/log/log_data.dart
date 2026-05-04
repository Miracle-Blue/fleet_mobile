import 'package:flutter/foundation.dart' show immutable, ValueGetter;

import '../extension/datetime_extension.dart';
import '../extension/string_extension.dart';
import 'gps_data.dart';
import 'logs_type.dart';

@immutable
final class LogData {
  const LogData({
    required this.address,
    required this.certifyTime,
    required this.coDriver,
    required this.companyId,
    required this.driverId,
    required this.driverSign,
    required this.endTime,
    required this.engineHours,
    required this.note,
    required this.odometer,
    required this.document,
    required this.startTime,
    required this.trailer,
    required this.unit,
    required this.vinNumber,
    required this.logType,
    required this.createdAt,
    required this.updatedAt,
    this.id = '',
    this.eldDebugData = '',
    this.speed = 0,
    this.eldAutoChanged = false,
  });

  factory LogData.fromJson(Map<String, Object?> json) {
    if (json case <String, Object?>{
      'id': final String id,
      'event_code': final num? eventCode,
      'event_type': final num? eventType,
      'company_id': final String? companyId,
      'unit_id': final String? unitId,
      'unit_number': final Object? unitNumber,
      'driver_id': final String? driverId,
      'co_driver_id': final String? coDriverId,
      'co_driver': final Map<String, Object?>? coDriver,
      'address': final Map<String, Object?>? address,
      'engine_hours': final num? engineHours,
      'odometer': final num? odometer,
      'vin_number': final String? vinNumber,
      'note': final String? note,
      'trailer': final String? trailer,
      'shipping_document': final String? document,
      'driver_sign': final String? driverSign,
      'certify_time': final String? certifyTime,
      'start_time': final String? startTime,
      'end_time': final String? endTime,
      'created_at': final String? createdAt,
      'updated_at': final String? updatedAt,
      'speed': final num? speed,
      'debug_data': final String? eldDebugData,
    }) {
      GpsData? gpsData;
      if (address case <String, Object?>{
        'address': final String? address,
        'state': final String? state,
        'eld_coordinates': <String, Object?>{'lat': final num? eldLat, 'lng': final num? eldLng},
        'fused_coordinates': <String, Object?>{'lat': final num? fusedLat, 'lng': final num? fusedLng},
        'gps_coordinates': <String, Object?>{'lat': final num? gpsLat, 'lng': final num? gpsLng},
      }) {
        gpsData = GpsData(
          eldCoordinates: (latitude: eldLat?.toDouble() ?? 0.0, longitude: eldLng?.toDouble() ?? 0.0),
          gpsCoordinates: (latitude: gpsLat?.toDouble() ?? 0.0, longitude: gpsLng?.toDouble() ?? 0.0),
          fusedCoordinates: (latitude: fusedLat?.toDouble() ?? 0.0, longitude: fusedLng?.toDouble() ?? 0.0),
          location: address ?? '',
          state: state ?? '',
        );
      }

      return LogData(
        id: id,
        logType: LogsType.fromEventTypeAndCode(eventType: eventType?.toInt() ?? 0, eventCode: eventCode?.toInt() ?? 0),
        companyId: companyId ?? '',
        unit: (id: unitId ?? '', number: unitNumber?.toString() ?? ''),
        driverId: driverId ?? '',
        coDriver: (id: coDriverId ?? '', name: coDriver != null ? coDriver['label'] as String? ?? '' : ''),
        address:
            gpsData ??
            const GpsData(
              eldCoordinates: null,
              gpsCoordinates: (latitude: 0.0, longitude: 0.0),
              fusedCoordinates: (latitude: 0.0, longitude: 0.0),
              location: '',
              state: '',
            ),
        odometer: odometer?.toInt() ?? 0,
        engineHours: engineHours?.toDouble() ?? 0.0,
        vinNumber: vinNumber ?? '',
        note: note ?? '',
        trailer: trailer ?? '',
        document: document ?? '',
        driverSign: driverSign ?? '',
        certifyTime: certifyTime ?? '',
        startTime: startTime?.fromGarbageToCompanyDateTime ?? DateTime.now(),
        endTime: endTime?.fromGarbageToCompanyDateTime ?? DateTime.now(),
        createdAt: createdAt?.fromGarbageToCompanyDateTime ?? DateTime.now(),
        updatedAt: updatedAt?.fromGarbageToCompanyDateTime ?? DateTime.now(),
        speed: speed?.toInt() ?? 0,
        eldDebugData: eldDebugData ?? '',
      );
    }

    throw FormatException('LogData.fromJson > Invalid response body: ${json.toString()}');
  }

  final String id;
  final GpsData address;
  final String certifyTime;
  final ({String id, String name}) coDriver;
  final String companyId;
  final String driverId;
  final String driverSign;
  final int odometer;
  final double engineHours;
  final DateTime startTime;
  final DateTime? endTime;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String note;
  final String trailer;
  final String document;
  final ({String id, String number}) unit;
  final String vinNumber;
  final int speed;
  final String eldDebugData;
  final LogsType logType;

  /// When the ELD is auto-changed, we need to give originCode 1 to the model
  ///
  /// Otherwise, we need to give originCode logType.originCode
  final bool eldAutoChanged;

  Map<String, Object?> toJson() => {
    'address': address.toChangeStatusJson(),
    'certify_time': certifyTime, // TODO(Miracle): need to change normal time format
    'debug_data': eldDebugData,
    'co_driver_id': coDriver.id,
    'co_driver': {'value': coDriver.id, 'label': coDriver.name},
    'company_id': companyId,
    'driver_id': driverId,
    'driver_sign': driverSign,
    'engine_hours': engineHours,
    'odometer': odometer,
    'note': note,
    'trailer': trailer,
    'shipping_document': document,
    'start_time': startTime.dateTime$yyyyMMddHHmmss, // TODO(Miracle): need to change normal time format
    'end_time': endTime?.dateTime$yyyyMMddHHmmss ?? '', // TODO(Miracle): need to change normal time format
    'created_at': createdAt.dateTime$yyyyMMddHHmmss, // TODO(Miracle): need to change normal time format
    'updated_at': updatedAt.dateTime$yyyyMMddHHmmss, // TODO(Miracle): need to change normal time format
    'unit_id': unit.id,
    'unit_number': unit.number,
    'speed': speed,

    // *** Log type fields ***
    'event_code': logType.eventCode,
    'event_type': logType.eventType,
    'origin_code': eldAutoChanged ? 1 : logType.originCode, // 1 for auto, 2 for manual
    'status': logType.type,

    // *** Static fields ***
    'vin_number': vinNumber,
    'creator': 'driver',
    'eld_address': '',
    'id': id,
    'increment_id': 0,
    'is_locked': false,
  };

  LogData copyWith({
    ValueGetter<String?>? id,
    ValueGetter<GpsData?>? address,
    ValueGetter<String?>? certifyTime,
    ValueGetter<({String id, String name})?>? coDriver,
    ValueGetter<String?>? companyId,
    ValueGetter<String?>? driverId,
    ValueGetter<String?>? driverSign,
    ValueGetter<int?>? odometer,
    ValueGetter<double?>? engineHours,
    ValueGetter<DateTime?>? startTime,
    ValueGetter<DateTime?>? endTime,
    ValueGetter<DateTime?>? createdAt,
    ValueGetter<DateTime?>? updatedAt,
    ValueGetter<String?>? note,
    ValueGetter<String?>? trailer,
    ValueGetter<String?>? document,
    ValueGetter<({String id, String number})?>? unit,
    ValueGetter<String?>? vinNumber,
    ValueGetter<int?>? speed,
    ValueGetter<String?>? eldDebugData,
    ValueGetter<LogsType?>? logType,
    ValueGetter<bool?>? eldAutoChanged,
  }) => LogData(
    id: id?.call() ?? this.id,
    address: address?.call() ?? this.address,
    certifyTime: certifyTime?.call() ?? this.certifyTime,
    coDriver: coDriver?.call() ?? this.coDriver,
    companyId: companyId?.call() ?? this.companyId,
    driverId: driverId?.call() ?? this.driverId,
    driverSign: driverSign?.call() ?? this.driverSign,
    odometer: odometer?.call() ?? this.odometer,
    engineHours: engineHours?.call() ?? this.engineHours,
    startTime: startTime?.call() ?? this.startTime,
    endTime: endTime?.call() ?? this.endTime,
    createdAt: createdAt?.call() ?? this.createdAt,
    updatedAt: updatedAt?.call() ?? this.updatedAt,
    note: note?.call() ?? this.note,
    trailer: trailer?.call() ?? this.trailer,
    document: document?.call() ?? this.document,
    unit: unit?.call() ?? this.unit,
    vinNumber: vinNumber?.call() ?? this.vinNumber,
    speed: speed?.call() ?? this.speed,
    eldDebugData: eldDebugData?.call() ?? this.eldDebugData,
    logType: logType?.call() ?? this.logType,
    eldAutoChanged: eldAutoChanged?.call() ?? this.eldAutoChanged,
  );

  @override
  bool operator ==(covariant LogData other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.address == address &&
        other.certifyTime == certifyTime &&
        other.coDriver == coDriver &&
        other.companyId == companyId &&
        other.driverId == driverId &&
        other.driverSign == driverSign &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.endTime == endTime &&
        other.engineHours == engineHours &&
        other.note == note &&
        other.odometer == odometer &&
        other.document == document &&
        other.startTime == startTime &&
        other.trailer == trailer &&
        other.unit == unit &&
        other.vinNumber == vinNumber &&
        other.speed == speed &&
        other.eldDebugData == eldDebugData &&
        other.logType == logType &&
        other.eldAutoChanged == eldAutoChanged;
  }

  @override
  int get hashCode =>
      address.hashCode ^
      id.hashCode ^
      certifyTime.hashCode ^
      coDriver.hashCode ^
      companyId.hashCode ^
      driverId.hashCode ^
      driverSign.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      endTime.hashCode ^
      engineHours.hashCode ^
      note.hashCode ^
      odometer.hashCode ^
      document.hashCode ^
      startTime.hashCode ^
      trailer.hashCode ^
      unit.hashCode ^
      vinNumber.hashCode ^
      speed.hashCode ^
      eldDebugData.hashCode ^
      logType.hashCode ^
      eldAutoChanged.hashCode;

  @override
  String toString() =>
      'DutyStatusData('
      'id: $id, '
      'address: $address, '
      'certifyTime: $certifyTime, '
      'coDriver: $coDriver, '
      'companyId: $companyId, '
      'driverId: $driverId, '
      'driverSign: $driverSign, '
      'createdAt: $createdAt, '
      'updatedAt: $updatedAt, '
      'endTime: $endTime, '
      'engineHours: $engineHours, '
      'note: $note, '
      'odometer: $odometer, '
      'document: $document, '
      'startTime: $startTime, '
      'trailer: $trailer, '
      'unit: $unit, '
      'vinNumber: $vinNumber, '
      'speed: $speed, '
      'eldDebugData: $eldDebugData, '
      'logType: $logType, '
      'eldAutoChanged: $eldAutoChanged)';
}
