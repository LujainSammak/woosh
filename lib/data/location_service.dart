import 'package:geolocator/geolocator.dart';

enum LocationFailure { serviceOff, denied, deniedForever, unavailable }

class LocationException implements Exception {
  final LocationFailure failure;
  const LocationException(this.failure);
}

class LocationService {
  Future<({double lat, double lon})> current() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationException(LocationFailure.serviceOff);
    }

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied) {
      throw const LocationException(LocationFailure.denied);
    }
    if (perm == LocationPermission.deniedForever) {
      throw const LocationException(LocationFailure.deniedForever);
    }

    try {
      // Low accuracy = approximate location. Enough for weather, better for privacy.
      final p = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 15),
        ),
      );
      return (lat: p.latitude, lon: p.longitude);
    } catch (_) {
      throw const LocationException(LocationFailure.unavailable);
    }
  }
}