import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/sky_palette.dart';
import '../../core/widgets/sky_scene.dart';
import '../../domain/alerts.dart';
import '../../domain/settings.dart';
import '../../domain/weather.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/location_choice.dart';
import '../../providers/settings_provider.dart';
import '../../providers/weather_provider.dart';
import '../search/search_screen.dart';
import '../settings/settings_screen.dart';
import 'condition_icon.dart';
import 'error_view.dart';
import 'offline_banner.dart';
import 'weather_layout.dart';
import 'widgets/hero_header.dart';
import 'widgets/sheet_sections.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = SkyPalette.of(context);
    final async = ref.watch(weatherProvider);

    return Scaffold(
      backgroundColor: p.sheet,
      body: async.when(
        loading: () => const SafeArea(
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => const SafeArea(
          child: ErrorView(error: WeatherError.network),
        ),
        data: (r) => r.weather != null
            ? _WeatherView(
                w: r.weather!,
                offline: r.offline,
                updatedAt: r.updatedAt,
              )
            : SafeArea(child: ErrorView(error: r.error!)),
      ),
    );
  }
}

/// 0 at sunrise, 1 at sunset; null when the sun is down.
double? sunProgress(DateTime now, DateTime sunrise, DateTime sunset) {
  if (!now.isAfter(sunrise) || !now.isBefore(sunset)) return null;
  return now.difference(sunrise).inSeconds /
      sunset.difference(sunrise).inSeconds;
}

SceneWeather sceneFor(WeatherCondition c) => switch (c) {
      WeatherCondition.clear => SceneWeather.clear,
      WeatherCondition.partlyCloudy => SceneWeather.partlyCloudy,
      WeatherCondition.overcast => SceneWeather.overcast,
      WeatherCondition.fog => SceneWeather.fog,
      WeatherCondition.drizzle || WeatherCondition.rain => SceneWeather.rain,
      WeatherCondition.snow => SceneWeather.snow,
      WeatherCondition.thunderstorm => SceneWeather.storm,
    };

String _conditionText(AppLocalizations t, WeatherCondition c) => switch (c) {
      WeatherCondition.clear => t.condClear,
      WeatherCondition.partlyCloudy => t.condPartlyCloudy,
      WeatherCondition.overcast => t.condOvercast,
      WeatherCondition.fog => t.condFog,
      WeatherCondition.drizzle => t.condDrizzle,
      WeatherCondition.rain => t.condRain,
      WeatherCondition.snow => t.condSnow,
      WeatherCondition.thunderstorm => t.condThunder,
    };

String _reasonText(AppLocalizations t, FeelsReason r) => switch (r) {
      FeelsReason.colderWind => t.reasonColderWind,
      FeelsReason.colderOther => t.reasonColderOther,
      FeelsReason.warmerHumid => t.reasonWarmerHumid,
      FeelsReason.warmerOther => t.reasonWarmerOther,
      FeelsReason.similar => t.reasonSimilar,
    };

(AlertKind, String) _alertInfo(AppLocalizations t, AlertType a) => switch (a) {
      AlertType.umbrella => (AlertKind.umbrella, t.alertUmbrella),
      AlertType.sunscreen => (AlertKind.sunscreen, t.alertSunscreen),
      AlertType.strongWind => (AlertKind.wind, t.alertWind),
      AlertType.heat => (AlertKind.heat, t.alertHeat),
      AlertType.cold => (AlertKind.cold, t.alertCold),
    };

String _uvLevel(AppLocalizations t, double uv) {
  if (uv < 3) return t.uvLow;
  if (uv < 6) return t.uvModerate;
  if (uv < 8) return t.uvHigh;
  if (uv < 11) return t.uvVeryHigh;
  return t.uvExtreme;
}

Color _iconColor(WeatherCondition c, bool isDay) => switch (c) {
      WeatherCondition.clear =>
        isDay ? const Color(0xFFF2B01E) : const Color(0xFF8A9BB0),
      WeatherCondition.drizzle ||
      WeatherCondition.rain =>
        const Color(0xFF4A90D9),
      WeatherCondition.snow => const Color(0xFF5BB6E8),
      WeatherCondition.thunderstorm => const Color(0xFFE8A21A),
      _ => const Color(0xFF8A9BB0),
    };

Widget _coloredIcon(WeatherCondition c, bool isDay) =>
    Icon(conditionIcon(c, isDay), color: _iconColor(c, isDay));

class _WeatherView extends ConsumerWidget {
  final Weather w;
  final bool offline;
  final DateTime? updatedAt;
  const _WeatherView({
    required this.w,
    this.offline = false,
    this.updatedAt,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final p = SkyPalette.of(context);
    final u = ref.watch(settingsProvider).value ?? const Settings();
    final place = ref.watch(choiceProvider).value;
    final cond = conditionFor(w.weatherCode);
    final locale = Localizations.localeOf(context).toString();
    final hm = DateFormat.Hm(locale);
    final dayName = DateFormat.E(locale);
    final alerts = alertsFor(w);
    final sp = sunProgress(w.time, w.sunrise, w.sunset);
    final reason = _reasonText(t, feelsReasonFor(w));

    return WeatherLayout(
      sunProgress: sp ?? (w.time.isBefore(w.sunrise) ? 0.0 : 1.0),
      weather: sceneFor(cond),
      onRefresh: () async {
        ref.invalidate(weatherProvider);
        await ref.read(weatherProvider.future);
      },
      header: HeroHeader(
        placeName: place?.label ?? t.myLocation,
        dateText:
            '${DateFormat.MMMMEEEEd(locale).format(w.time)} · ${hm.format(w.time)}',
        temperature: u.temp(w.temp),
        condition: _conditionText(t, cond),
        conditionIcon: Icon(conditionIcon(cond, w.isDay)),
        feelsLike: '${t.feelsLike} ${u.temp(w.feelsLike)} · $reason',
        highLow: '${u.temp(w.tempMin)} / ${u.temp(w.tempMax)}',
        searchLabel: t.searchCity,
        settingsLabel: t.settings,
        onUseMyLocation: place == null
            ? null
            : () => ref.read(choiceProvider.notifier).useGps(),
        useMyLocationLabel: t.useMyLocation,
        onSearch: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SearchScreen()),
        ),
        onSettings: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SettingsScreen()),
        ),
      ),
      sections: [
        if (offline && updatedAt != null)
          OfflineBanner(updatedAt: updatedAt!, color: p.hairline),
        if (alerts.isNotEmpty)
          Column(
            children: [
              for (var i = 0; i < alerts.length; i++) ...[
                if (i > 0) const SizedBox(height: 10),
                Builder(builder: (_) {
                  final info = _alertInfo(t, alerts[i]);
                  return AlertTile(kind: info.$1, title: info.$2);
                }),
              ],
            ],
          ),
        if (w.hourly.isNotEmpty)
          SheetSection(
            title: t.forecastHourly,
            child: HourlyStrip(entries: [
              for (var i = 0; i < w.hourly.length; i++)
                HourlyEntry(
                  label: i == 0 ? t.now : hm.format(w.hourly[i].time),
                  icon: _coloredIcon(
                      conditionFor(w.hourly[i].code), w.hourly[i].isDay),
                  temp: u.temp(w.hourly[i].temp),
                  rain: w.hourly[i].rainChance >= 20
                      ? '${w.hourly[i].rainChance}%'
                      : null,
                  isNow: i == 0,
                ),
            ]),
          ),
        if (w.daily.isNotEmpty)
          SheetSection(
            title: t.forecastDaily,
            child: DailyList(entries: [
              for (var i = 0; i < w.daily.length; i++)
                DailyEntry(
                  label: i == 0 ? t.today : dayName.format(w.daily[i].date),
                  icon: _coloredIcon(conditionFor(w.daily[i].code), true),
                  lowText: u.temp(w.daily[i].tempMin),
                  highText: u.temp(w.daily[i].tempMax),
                  low: w.daily[i].tempMin,
                  high: w.daily[i].tempMax,
                  rain: w.daily[i].rainChance >= 20
                      ? '${w.daily[i].rainChance}%'
                      : null,
                ),
            ]),
          ),
        SheetSection(
          title: t.details,
          child: Column(
            children: [
              StatGrid(stats: [
                StatBlock(
                  label: t.feelsLike,
                  value: u.temp(w.feelsLike),
                  caption: reason,
                ),
                StatBlock(label: t.rainChance, value: '${w.rainNext3h}%'),
                StatBlock(label: t.humidity, value: '${w.humidity}%'),
                StatBlock(
                  label: t.wind,
                  value: u.wind(w.windKmh),
                  trailing: Transform.rotate(
                    angle: (w.windDir + 180) * math.pi / 180,
                    child: Icon(Icons.navigation_rounded,
                        size: 20, color: p.inkMuted),
                  ),
                ),
              ]),
              Divider(height: 1, thickness: 1, color: p.hairline),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: UvScale(
                  label: t.uvIndex,
                  value: w.uv.toStringAsFixed(1),
                  level: _uvLevel(t, w.uv),
                  uv: w.uv,
                ),
              ),
            ],
          ),
        ),
        SheetSection(
          title: t.sunTitle,
          child: SunArc(
            sunriseLabel: t.sunrise,
            sunrise: hm.format(w.sunrise),
            sunsetLabel: t.sunset,
            sunset: hm.format(w.sunset),
            progress: sp,
          ),
        ),
      ],
    );
  }
}