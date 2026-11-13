import 'package:flutter_test/flutter_test.dart';
import 'package:woosh/domain/weather.dart';

/// 7 days of hourly data (Oct 14-20) and 7 daily entries.
Map<String, dynamic> sample({bool withHourlyTemps = true}) {
  final times = <String>[];
  final temps = <num?>[];
  final probs = <num?>[];
  final codes = <num>[];
  final isDay = <num>[];
  for (var d = 14; d <= 20; d++) {
    for (var h = 0; h < 24; h++) {
      times.add('2026-10-$d' 'T${h.toString().padLeft(2, '0')}:00');
      temps.add(h);
      // 17:00 on day 14 has a missing value; 19:00 on day 14 has 60%
      probs.add((d == 14 && h == 17) ? null : ((d == 14 && h == 19) ? 60 : 0));
      codes.add(0);
      isDay.add(h >= 7 && h < 18 ? 1 : 0);
    }
  }
  return {
    'current': {
      'time': '2026-10-14T16:00',
      'temperature_2m': 20,
      'relative_humidity_2m': 50,
      'apparent_temperature': 20,
      'is_day': 1,
      'weather_code': 0,
      'wind_speed_10m': 10,
      'wind_direction_10m': 90,
      'uv_index': 2,
    },
    'hourly': {
      'time': times,
      if (withHourlyTemps) 'temperature_2m': temps,
      'precipitation_probability': probs,
      'weather_code': codes,
      'is_day': isDay,
    },
    'daily': {
      'time': [for (var d = 14; d <= 20; d++) '2026-10-$d'],
      'sunrise': [for (var d = 14; d <= 20; d++) '2026-10-$d' 'T07:$d'],
      'sunset': [for (var d = 14; d <= 20; d++) '2026-10-$d' 'T18:$d'],
      'uv_index_max': [for (var d = 14; d <= 20; d++) 5],
      'temperature_2m_max': [for (var d = 14; d <= 20; d++) 20 + d],
      'temperature_2m_min': [for (var d = 14; d <= 20; d++) 10],
      'precipitation_probability_max': [for (var d = 14; d <= 20; d++) 30],
      'weather_code': [for (var d = 14; d <= 20; d++) 3],
    },
  };
}

void main() {
  group('hourly', () {
    test('starts at the current hour and has 24 entries', () {
      final w = Weather.fromJson(sample());
      expect(w.hourly.length, 24);
      expect(w.hourly.first.time.hour, 16);
      expect(w.hourly.first.temp, 16);
      expect(w.hourly.last.time.hour, 15);
    });

    test('a missing rain value counts as 0 and does not crash', () {
      final w = Weather.fromJson(sample());
      final at17 = w.hourly.firstWhere((p) => p.time.hour == 17);
      expect(at17.rainChance, 0);
    });

    test('aged 3 hours: starts at 19:00 and sees the 60% rain', () {
      final w = Weather.fromJson(sample(), shift: const Duration(hours: 3));
      expect(w.hourly.first.time.hour, 19);
      expect(w.rainNext3h, 60);
    });

    test('missing hourly temperatures gives an empty list, no crash', () {
      final w = Weather.fromJson(sample(withHourlyTemps: false));
      expect(w.hourly, isEmpty);
    });
  });

  group('daily', () {
    test('7 days starting today', () {
      final w = Weather.fromJson(sample());
      expect(w.daily.length, 7);
      expect(w.daily.first.date.day, 14);
      expect(w.daily.first.tempMax, 34);
      expect(w.daily.first.rainChance, 30);
    });

    test('aged past midnight: today moves to the 15th with its own sunrise', () {
      final w = Weather.fromJson(sample(), shift: const Duration(hours: 10));
      expect(w.time.day, 15);
      expect(w.daily.first.date.day, 15);
      expect(w.daily.length, 6);
      expect(w.sunrise.minute, 15);
      expect(w.tempMax, 35);
    });
  });
}