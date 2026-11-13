import 'package:flutter/material.dart';
import '../../domain/alerts.dart';

IconData conditionIcon(WeatherCondition c, bool isDay) => switch (c) {
      WeatherCondition.clear =>
        isDay ? Icons.wb_sunny : Icons.nightlight_round,
      WeatherCondition.partlyCloudy =>
        isDay ? Icons.wb_cloudy : Icons.nights_stay,
      WeatherCondition.overcast => Icons.cloud,
      WeatherCondition.fog => Icons.blur_on,
      WeatherCondition.drizzle => Icons.grain,
      WeatherCondition.rain => Icons.water_drop,
      WeatherCondition.snow => Icons.ac_unit,
      WeatherCondition.thunderstorm => Icons.flash_on,
    };