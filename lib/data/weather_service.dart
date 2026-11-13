import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/weather.dart';

class WeatherService {
  WeatherService({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  /// Returns the raw JSON text (so it can be cached as-is).
  Future<String> fetchRaw(double lat, double lon) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      // Rounded to 2 decimals (~1 km): enough for weather, less precise to send.
      'latitude': lat.toStringAsFixed(2),
      'longitude': lon.toStringAsFixed(2),
      'current': 'temperature_2m,relative_humidity_2m,apparent_temperature,'
          'is_day,weather_code,wind_speed_10m,wind_direction_10m,uv_index',
      'hourly': 'temperature_2m,precipitation_probability,weather_code,is_day',
      'daily': 'weather_code,sunrise,sunset,uv_index_max,temperature_2m_max,'
          'temperature_2m_min,precipitation_probability_max',
      'timezone': 'auto',
      'forecast_days': '7',
    });

    final res = await _client.get(uri).timeout(const Duration(seconds: 10));
    if (res.statusCode != 200) {
      throw Exception('Weather request failed: ${res.statusCode}');
    }
    return utf8.decode(res.bodyBytes);
  }

  Future<Weather> fetch(double lat, double lon) async {
    final raw = await fetchRaw(lat, lon);
    return Weather.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}