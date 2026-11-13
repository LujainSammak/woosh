import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CachedWeather {
  final DateTime savedAt;
  final String body;
  const CachedWeather(this.savedAt, this.body);
}

/// Keeps only the most recent weather response, on this device only.
/// It is keyed by coordinates rounded to 2 decimals (about 1 km), so data
/// for one place is never shown for another.
class WeatherCache {
  static const prefsKey = 'wx_cache_v2';

  static String keyFor(double lat, double lon) =>
      '${lat.toStringAsFixed(2)},${lon.toStringAsFixed(2)}';

  Future<void> save(String key, String body) async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString(
        prefsKey,
        jsonEncode({
          'key': key,
          't': DateTime.now().millisecondsSinceEpoch,
          'body': body,
        }),
      );
    } catch (_) {}
  }

  Future<CachedWeather?> load(String key) async {
    try {
      final p = await SharedPreferences.getInstance();
      final raw = p.getString(prefsKey);
      if (raw == null) return null;
      final m = jsonDecode(raw) as Map<String, dynamic>;
      if (m['key'] != key) return null;
      final t = m['t'];
      final body = m['body'];
      if (t is! int || body is! String) return null;
      return CachedWeather(DateTime.fromMillisecondsSinceEpoch(t), body);
    } catch (_) {
      return null;
    }
  }
}