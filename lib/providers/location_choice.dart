import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/place.dart';

/// null = use the phone's location. Otherwise the saved city.
class LocationChoice extends AsyncNotifier<Place?> {
  static const _kLabel = 'place_label';
  static const _kLat = 'place_lat';
  static const _kLon = 'place_lon';

  @override
  Future<Place?> build() async {
    final p = await SharedPreferences.getInstance();
    final label = p.getString(_kLabel);
    final lat = p.getDouble(_kLat);
    final lon = p.getDouble(_kLon);
    if (label == null || lat == null || lon == null) return null;
    if (!Place.validCoords(lat, lon)) return null;
    return Place(label: label, lat: lat, lon: lon);
  }

  Future<void> select(Place place) async {
    state = AsyncData(place);
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString(_kLabel, place.label);
      await p.setDouble(_kLat, place.lat);
      await p.setDouble(_kLon, place.lon);
    } catch (_) {}
  }

  Future<void> useGps() async {
    state = const AsyncData(null);
    try {
      final p = await SharedPreferences.getInstance();
      await p.remove(_kLabel);
      await p.remove(_kLat);
      await p.remove(_kLon);
    } catch (_) {}
  }
}

final choiceProvider =
    AsyncNotifierProvider<LocationChoice, Place?>(LocationChoice.new);