import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/sky_phase.dart';
import '../data/location_service.dart';
import '../data/weather_cache.dart';
import '../data/weather_service.dart';
import '../domain/weather.dart';
import 'location_choice.dart';

enum WeatherError { locationOff, locationDenied, locationForever, network, data }

/// Saved data older than this is not shown (weather is too stale to be useful).
const maxCacheAge = Duration(hours: 6);

class WeatherResult {
  final Weather? weather;
  final WeatherError? error;
  final bool offline;
  final DateTime? updatedAt;
  const WeatherResult.ok(Weather w, {this.offline = false, this.updatedAt})
      : weather = w,
        error = null;
  const WeatherResult.fail(WeatherError e)
      : weather = null,
        error = e,
        offline = false,
        updatedAt = null;
}

/// Uses the saved city if there is one, otherwise the phone's location.
/// If the request fails, falls back to recent saved data for the same place.
final weatherProvider = FutureProvider<WeatherResult>((ref) async {
  final choice = await ref.watch(choiceProvider.future);

  ({double lat, double lon}) pos;
  try {
    pos = choice != null
        ? (lat: choice.lat, lon: choice.lon)
        : await LocationService().current();
  } on LocationException catch (e) {
    return WeatherResult.fail(switch (e.failure) {
      LocationFailure.serviceOff => WeatherError.locationOff,
      LocationFailure.denied => WeatherError.locationDenied,
      LocationFailure.deniedForever => WeatherError.locationForever,
      LocationFailure.unavailable => WeatherError.locationDenied,
    });
  }

  final cache = WeatherCache();
  final key = WeatherCache.keyFor(pos.lat, pos.lon);

  try {
    final raw = await WeatherService().fetchRaw(pos.lat, pos.lon);
    final w = Weather.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    await cache.save(key, raw);
    return WeatherResult.ok(w);
  } catch (e) {
    final isDataError = e is FormatException || e is TypeError;

    final c = await cache.load(key);
    if (c != null) {
      final age = DateTime.now().difference(c.savedAt);
      if (!age.isNegative && age <= maxCacheAge) {
        try {
          final w = Weather.fromJson(
            jsonDecode(c.body) as Map<String, dynamic>,
            shift: age,
          );
          return WeatherResult.ok(w, offline: true, updatedAt: c.savedAt);
        } catch (_) {}
      }
    }
    return WeatherResult.fail(
      isDataError ? WeatherError.data : WeatherError.network,
    );
  }
});

/// Phase comes from the real sunrise/sunset at the chosen place.
final skyPhaseProvider = Provider<SkyPhase>((ref) {
  final w = ref.watch(weatherProvider).value?.weather;
  if (w != null) return skyPhaseFor(w.time, w.sunrise, w.sunset);
  final h = DateTime.now().hour;
  return (h >= 6 && h < 18) ? SkyPhase.day : SkyPhase.night;
});