import 'weather.dart';

enum AlertType { umbrella, sunscreen, strongWind, heat, cold }

enum WeatherCondition {
  clear,
  partlyCloudy,
  overcast,
  fog,
  drizzle,
  rain,
  snow,
  thunderstorm,
}

enum FeelsReason { colderWind, colderOther, warmerHumid, warmerOther, similar }

// Thresholds (kept in one place so they are easy to review and change).
const umbrellaRainChance = 40; // % chance in the next 3 hours
const sunscreenUv = 3.0; // WHO: sun protection recommended from UV 3
const strongWindKmh = 40.0; // roughly "strong breeze" and above
const heatFeelsLike = 35.0; // °C
const coldFeelsLike = 0.0; // °C

/// Maps WMO weather codes (used by Open-Meteo) to a simple condition.
WeatherCondition conditionFor(int code) {
  if (code == 0 || code == 1) return WeatherCondition.clear;
  if (code == 2) return WeatherCondition.partlyCloudy;
  if (code == 3) return WeatherCondition.overcast;
  if (code == 45 || code == 48) return WeatherCondition.fog;
  if (code >= 51 && code <= 57) return WeatherCondition.drizzle;
  if ((code >= 61 && code <= 67) || (code >= 80 && code <= 82)) {
    return WeatherCondition.rain;
  }
  if ((code >= 71 && code <= 77) || code == 85 || code == 86) {
    return WeatherCondition.snow;
  }
  if (code >= 95) return WeatherCondition.thunderstorm;
  return WeatherCondition.overcast;
}

bool _rainingNow(int code) {
  final c = conditionFor(code);
  return c == WeatherCondition.drizzle ||
      c == WeatherCondition.rain ||
      c == WeatherCondition.thunderstorm;
}

List<AlertType> alertsFor(Weather w) {
  final alerts = <AlertType>[];

  if (w.rainNext3h >= umbrellaRainChance || _rainingNow(w.weatherCode)) {
    alerts.add(AlertType.umbrella);
  }
  if (w.isDay && w.uv >= sunscreenUv) {
    alerts.add(AlertType.sunscreen);
  }
  if (w.windKmh >= strongWindKmh) {
    alerts.add(AlertType.strongWind);
  }
  if (w.feelsLike >= heatFeelsLike) {
    alerts.add(AlertType.heat);
  }
  if (w.feelsLike <= coldFeelsLike) {
    alerts.add(AlertType.cold);
  }
  return alerts;
}

FeelsReason feelsReasonFor(Weather w) {
  final diff = w.feelsLike - w.temp;
  if (diff <= -2) {
    return w.windKmh >= 15 ? FeelsReason.colderWind : FeelsReason.colderOther;
  }
  if (diff >= 2) {
    return w.humidity >= 60 ? FeelsReason.warmerHumid : FeelsReason.warmerOther;
  }
  return FeelsReason.similar;
}