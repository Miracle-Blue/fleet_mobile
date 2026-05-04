import 'package:meta/meta.dart';

@immutable
class GpsData {
  const GpsData({
    required this.eldCoordinates,
    required this.gpsCoordinates,
    required this.fusedCoordinates,
    required this.location,
    required this.state,
  });

  final ({double latitude, double longitude})? eldCoordinates;
  final ({double latitude, double longitude}) gpsCoordinates;
  final ({double latitude, double longitude}) fusedCoordinates;
  final String location;
  final String state;

  Map<String, Object?> toJson() => {
    'address': location,
    'state': state,
    'eld_latitude': eldCoordinates?.latitude ?? 0.0,
    'eld_longitude': eldCoordinates?.longitude ?? 0.0,
    'gps_latitude': gpsCoordinates.latitude,
    'gps_longitude': gpsCoordinates.longitude,
    'fused_latitude': fusedCoordinates.latitude,
    'fused_longitude': fusedCoordinates.longitude,
    'latitude': eldCoordinates?.latitude ?? gpsCoordinates.latitude,
    'longitude': eldCoordinates?.longitude ?? gpsCoordinates.longitude,
  };

  Map<String, Object?> toChangeStatusJson() => {
    'address': location,
    'coordinates': {
      'lat': eldCoordinates?.latitude ?? gpsCoordinates.latitude,
      'lng': eldCoordinates?.longitude ?? gpsCoordinates.longitude,
    },
    'eld_coordinates': {'lat': eldCoordinates?.latitude ?? 0.0, 'lng': eldCoordinates?.longitude ?? 0.0},
    'fused_coordinates': {'lat': fusedCoordinates.latitude, 'lng': fusedCoordinates.longitude},
    'gps_coordinates': {'lat': gpsCoordinates.latitude, 'lng': gpsCoordinates.longitude},
    'state': state,
  };

  bool get isLocationEmpty => location.isEmpty || state.isEmpty;

  @override
  bool operator ==(covariant GpsData other) {
    if (identical(this, other)) return true;

    return other.eldCoordinates == eldCoordinates &&
        other.gpsCoordinates == gpsCoordinates &&
        other.fusedCoordinates == fusedCoordinates &&
        other.location == location &&
        other.state == state;
  }

  @override
  int get hashCode =>
      eldCoordinates.hashCode ^
      gpsCoordinates.hashCode ^
      fusedCoordinates.hashCode ^
      location.hashCode ^
      state.hashCode;

  @override
  String toString() =>
      'GpsData(eldCoordinates: $eldCoordinates, gpsCoordinates: $gpsCoordinates, fusedCoordinates: $fusedCoordinates, location: $location, state: $state)';
}
