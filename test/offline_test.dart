import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:woosh/data/weather_cache.dart';
import 'package:woosh/domain/settings.dart';
import 'package:woosh/domain/weather.dart';
import 'dart:convert';

const sample = '''
{"current":{"time":"2026-10-14T16:00","temperature_2m":20,"relative_humidity_2m":50,"apparent_temperature":20,"is_day":1,"weather_code":0,"wind_speed_10m":10,"wind_direction_10m":90,"uv_index":2},
"hourly":{"time":["2026-10-14T16:00","2026-10-14T17:00","2026-10-14T18:00","2026-10-14T19:00","2026-10-14T20:00"],"precipitation_probability":[0,0,0,60,10]},
"daily":{"sunrise":["2026-10-14T07:00"],"sunset":["2026-10-14T18:00"],"uv_index_max":[5],"temperature_2m_max":[22],"temperature_2m_min":[12]}}
''';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('units', () {
    test('Celsius and km/h by default', () {
      const s = Settings();
      expect(s.temp(21.4), '21°');
      expect(s.wind(100), '100 km/h');
    });
    test('Fahrenheit conversion', () {
      const s = Settings(fahrenheit: true);
      expect(s.temp(0), '32°');
      expect(s.temp(100), '212°');
      expect(s.temp(-40), '-40°');
    });
    test('mph conversion', () {
      const s = Settings(mph: true);
      expect(s.wind(100), '62 mph');
    });
  });

  group('cached weather aging', () {
    final json = jsonDecode(sample) as Map<String, dynamic>;

    test('no shift: fresh values', () {
      final w = Weather.fromJson(json);
      expect(w.time.hour, 16);
      expect(w.isDay, isTrue);
      expect(w.rainNext3h, 0);
    });

    test('3 hours later: it is night and the rain window moved', () {
      final w = Weather.fromJson(json, shift: const Duration(hours: 3));
      expect(w.time.hour, 19);
      expect(w.isDay, isFalse);
      expect(w.rainNext3h, 60);
    });
  });

  group('cache storage', () {
    test('saves and loads for the same place', () async {
      SharedPreferences.setMockInitialValues({});
      final c = WeatherCache();
      await c.save('41.01,28.95', '{"a":1}');
      final r = await c.load('41.01,28.95');
      expect(r, isNotNull);
      expect(r!.body, '{"a":1}');
      expect(DateTime.now().difference(r.savedAt).inSeconds < 5, isTrue);
    });

    test('a different place gets nothing', () async {
      SharedPreferences.setMockInitialValues({});
      final c = WeatherCache();
      await c.save('41.01,28.95', '{"a":1}');
      expect(await c.load('38.42,27.14'), isNull);
    });

    test('corrupted cache is ignored', () async {
      SharedPreferences.setMockInitialValues({WeatherCache.prefsKey: 'not json'});
      expect(await WeatherCache().load('41.01,28.95'), isNull);
    });

    test('key rounds to about 1 km', () {
      expect(WeatherCache.keyFor(41.0123, 28.9456), '41.01,28.95');
    });
  });
}