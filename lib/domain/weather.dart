class HourlyPoint {
  final DateTime time;
  final double temp;
  final int rainChance;
  final int code;
  final bool isDay;
  const HourlyPoint({
    required this.time,
    required this.temp,
    required this.rainChance,
    required this.code,
    required this.isDay,
  });
}

class DailyPoint {
  final DateTime date;
  final double tempMax;
  final double tempMin;
  final int rainChance;
  final int code;
  const DailyPoint({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.rainChance,
    required this.code,
  });
}

class Weather {
  /// "Now" in the location's own timezone (taken from the API, not the phone).
  final DateTime time;
  final double temp;
  final double feelsLike;
  final int humidity;
  final double windKmh;
  final int windDir;
  final double uv;
  final double uvMax;
  final double tempMax;
  final double tempMin;
  final int weatherCode;
  final bool isDay;
  final DateTime sunrise;
  final DateTime sunset;
  final int rainNext3h;
  final List<HourlyPoint> hourly;
  final List<DailyPoint> daily;

  const Weather({
    required this.time,
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.windKmh,
    required this.windDir,
    required this.uv,
    required this.uvMax,
    required this.tempMax,
    required this.tempMin,
    required this.weatherCode,
    required this.isDay,
    required this.sunrise,
    required this.sunset,
    required this.rainNext3h,
    this.hourly = const [],
    this.daily = const [],
  });

  /// [shift] ages cached data: "now" moves forward by the time since it was saved.
  factory Weather.fromJson(Map<String, dynamic> j,
      {Duration shift = Duration.zero}) {
    final cur = j['current'] as Map<String, dynamic>;
    final dailyJ = j['daily'] as Map<String, dynamic>;
    final hourlyJ = j['hourly'] as Map<String, dynamic>;

    final now = DateTime.parse(cur['time'] as String).add(shift);
    final hourStart = DateTime(now.year, now.month, now.day, now.hour);
    final hourEnd = hourStart.add(const Duration(hours: 3));
    final today = DateTime(now.year, now.month, now.day);

    List<dynamic> list(Map<String, dynamic> m, String k) =>
        (m[k] as List?) ?? const [];
    double? numAt(List<dynamic> l, int i) {
      if (i >= l.length) return null;
      final v = l[i];
      return v is num ? v.toDouble() : null;
    }

    // Hourly: next 24 hours from the current hour, plus the 3-hour rain window.
    final hTimes =
        list(hourlyJ, 'time').map((e) => DateTime.parse(e as String)).toList();
    final hTemp = list(hourlyJ, 'temperature_2m');
    final hProb = list(hourlyJ, 'precipitation_probability');
    final hCode = list(hourlyJ, 'weather_code');
    final hDay = list(hourlyJ, 'is_day');

    final hourly = <HourlyPoint>[];
    var maxProb = 0;
    for (var i = 0; i < hTimes.length; i++) {
      final t = hTimes[i];
      if (t.isBefore(hourStart)) continue;
      final prob = numAt(hProb, i)?.round() ?? 0;
      if (t.isBefore(hourEnd) && prob > maxProb) maxProb = prob;
      if (hourly.length < 24) {
        final temp = numAt(hTemp, i);
        if (temp != null) {
          hourly.add(HourlyPoint(
            time: t,
            temp: temp,
            rainChance: prob,
            code: (numAt(hCode, i) ?? 0).round(),
            isDay: (numAt(hDay, i) ?? 1) == 1,
          ));
        }
      }
    }

    // Daily: "today" is the entry matching the (aged) current date.
    final dTimes =
        list(dailyJ, 'time').map((e) => DateTime.parse(e as String)).toList();
    var ti = dTimes.indexWhere((d) =>
        d.year == today.year && d.month == today.month && d.day == today.day);
    if (ti < 0) ti = 0;

    final dMax = list(dailyJ, 'temperature_2m_max');
    final dMin = list(dailyJ, 'temperature_2m_min');
    final dProb = list(dailyJ, 'precipitation_probability_max');
    final dCode = list(dailyJ, 'weather_code');

    final daily = <DailyPoint>[];
    for (var i = 0; i < dTimes.length && daily.length < 7; i++) {
      if (dTimes[i].isBefore(today)) continue;
      final mx = numAt(dMax, i);
      final mn = numAt(dMin, i);
      if (mx == null || mn == null) continue;
      daily.add(DailyPoint(
        date: dTimes[i],
        tempMax: mx,
        tempMin: mn,
        rainChance: numAt(dProb, i)?.round() ?? 0,
        code: (numAt(dCode, i) ?? 0).round(),
      ));
    }

    final sunrise = DateTime.parse(list(dailyJ, 'sunrise')[ti] as String);
    final sunset = DateTime.parse(list(dailyJ, 'sunset')[ti] as String);

    return Weather(
      time: now,
      temp: (cur['temperature_2m'] as num).toDouble(),
      feelsLike: (cur['apparent_temperature'] as num).toDouble(),
      humidity: (cur['relative_humidity_2m'] as num).round(),
      windKmh: (cur['wind_speed_10m'] as num).toDouble(),
      windDir: (cur['wind_direction_10m'] as num).round(),
      uv: (cur['uv_index'] as num).toDouble(),
      uvMax: numAt(list(dailyJ, 'uv_index_max'), ti) ?? 0,
      tempMax: numAt(dMax, ti) ?? (cur['temperature_2m'] as num).toDouble(),
      tempMin: numAt(dMin, ti) ?? (cur['temperature_2m'] as num).toDouble(),
      weatherCode: (cur['weather_code'] as num).round(),
      isDay: shift == Duration.zero
          ? (cur['is_day'] as num) == 1
          : (now.isAfter(sunrise) && now.isBefore(sunset)),
      sunrise: sunrise,
      sunset: sunset,
      rainNext3h: maxProb,
      hourly: hourly,
      daily: daily,
    );
  }
}