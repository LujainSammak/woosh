import 'package:flutter_test/flutter_test.dart';
import 'package:woosh/domain/alerts.dart';
import 'package:woosh/domain/weather.dart';

Weather mk({
  double temp = 20,
  double feels = 20,
  int hum = 50,
  double wind = 10,
  double uv = 1,
  int code = 0,
  bool isDay = true,
  int rain = 0,
}) =>
    Weather(
      time: DateTime(2026, 10, 14, 12),
      temp: temp,
      feelsLike: feels,
      humidity: hum,
      windKmh: wind,
      windDir: 0,
      uv: uv,
      uvMax: uv,
      tempMax: temp,
      tempMin: temp,
      weatherCode: code,
      isDay: isDay,
      sunrise: DateTime(2026, 10, 14, 7),
      sunset: DateTime(2026, 10, 14, 18),
      rainNext3h: rain,
    );

void main() {
  group('umbrella', () {
    test('39% chance: no alert', () {
      expect(alertsFor(mk(rain: 39)), isNot(contains(AlertType.umbrella)));
    });
    test('40% chance: alert', () {
      expect(alertsFor(mk(rain: 40)), contains(AlertType.umbrella));
    });
    test('raining now (code 61) with low chance: alert', () {
      expect(alertsFor(mk(code: 61, rain: 10)), contains(AlertType.umbrella));
    });
    test('thunderstorm: alert', () {
      expect(alertsFor(mk(code: 95)), contains(AlertType.umbrella));
    });
  });

  group('sunscreen', () {
    test('UV 2.9 in daylight: no alert', () {
      expect(alertsFor(mk(uv: 2.9)), isNot(contains(AlertType.sunscreen)));
    });
    test('UV 3 in daylight: alert', () {
      expect(alertsFor(mk(uv: 3)), contains(AlertType.sunscreen));
    });
    test('high UV at night: no alert', () {
      expect(alertsFor(mk(uv: 8, isDay: false)),
          isNot(contains(AlertType.sunscreen)));
    });
  });

  group('wind, heat, cold', () {
    test('wind 39 no, 40 yes', () {
      expect(alertsFor(mk(wind: 39)), isNot(contains(AlertType.strongWind)));
      expect(alertsFor(mk(wind: 40)), contains(AlertType.strongWind));
    });
    test('heat uses feels-like: 34.9 no, 35 yes', () {
      expect(alertsFor(mk(feels: 34.9)), isNot(contains(AlertType.heat)));
      expect(alertsFor(mk(feels: 35)), contains(AlertType.heat));
    });
    test('cold uses feels-like: 0.1 no, 0 yes', () {
      expect(alertsFor(mk(feels: 0.1)), isNot(contains(AlertType.cold)));
      expect(alertsFor(mk(feels: 0)), contains(AlertType.cold));
    });
    test('mild day: no alerts', () {
      expect(alertsFor(mk()), isEmpty);
    });
  });

  group('condition codes', () {
    test('mapping', () {
      expect(conditionFor(0), WeatherCondition.clear);
      expect(conditionFor(2), WeatherCondition.partlyCloudy);
      expect(conditionFor(3), WeatherCondition.overcast);
      expect(conditionFor(45), WeatherCondition.fog);
      expect(conditionFor(53), WeatherCondition.drizzle);
      expect(conditionFor(63), WeatherCondition.rain);
      expect(conditionFor(81), WeatherCondition.rain);
      expect(conditionFor(73), WeatherCondition.snow);
      expect(conditionFor(95), WeatherCondition.thunderstorm);
    });
  });

  group('feels-like reason', () {
    test('colder with wind', () {
      expect(feelsReasonFor(mk(temp: 10, feels: 6, wind: 20)),
          FeelsReason.colderWind);
    });
    test('warmer with humidity', () {
      expect(feelsReasonFor(mk(temp: 30, feels: 34, hum: 70)),
          FeelsReason.warmerHumid);
    });
    test('similar', () {
      expect(feelsReasonFor(mk(temp: 20, feels: 21)), FeelsReason.similar);
    });
  });
}