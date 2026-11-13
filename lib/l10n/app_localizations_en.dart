// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Woosh';

  @override
  String get dawn => 'Dawn';

  @override
  String get day => 'Day';

  @override
  String get sunset => 'Sunset';

  @override
  String get night => 'Night';

  @override
  String get feelsLike => 'Feels like';

  @override
  String get humidity => 'Humidity';

  @override
  String get wind => 'Wind';

  @override
  String get uvIndex => 'UV index';

  @override
  String get sunrise => 'Sunrise';

  @override
  String get rainChance => 'Rain chance';

  @override
  String get retry => 'Try again';

  @override
  String get errLocationOff =>
      'Location services are off. Turn them on and try again.';

  @override
  String get errLocationDenied =>
      'Location permission is needed to show the weather where you are.';

  @override
  String get errLocationForever =>
      'Location permission was denied. Enable it in the app settings.';

  @override
  String get errNetwork =>
      'Couldn\'t connect to the internet. Check your connection and try again.';

  @override
  String get errData =>
      'Couldn\'t read the weather data. Please try again later.';

  @override
  String get condClear => 'Clear';

  @override
  String get condPartlyCloudy => 'Partly cloudy';

  @override
  String get condOvercast => 'Overcast';

  @override
  String get condFog => 'Foggy';

  @override
  String get condDrizzle => 'Drizzle';

  @override
  String get condRain => 'Rain';

  @override
  String get condSnow => 'Snow';

  @override
  String get condThunder => 'Thunderstorm';

  @override
  String get reasonColderWind => 'Wind makes it feel colder';

  @override
  String get reasonColderOther => 'Feels colder than the actual temperature';

  @override
  String get reasonWarmerHumid => 'Humidity makes it feel warmer';

  @override
  String get reasonWarmerOther => 'Feels warmer than the actual temperature';

  @override
  String get reasonSimilar => 'Close to the actual temperature';

  @override
  String get alertUmbrella => 'Take an umbrella, rain is expected.';

  @override
  String get alertSunscreen => 'Wear sunscreen, the UV index is high.';

  @override
  String get alertWind => 'Strong wind, take care outside.';

  @override
  String get alertHeat => 'Extreme heat, drink water and avoid the sun.';

  @override
  String get alertCold => 'Very cold, dress warmly.';

  @override
  String get searchCity => 'Search for a city';

  @override
  String get searchHint => 'City name';

  @override
  String get noResults => 'No cities found';

  @override
  String get myLocation => 'My location';

  @override
  String get useMyLocation => 'Use my location';

  @override
  String get settings => 'Settings';

  @override
  String get temperatureUnit => 'Temperature';

  @override
  String get windUnit => 'Wind speed';

  @override
  String get language => 'Language';

  @override
  String get systemDefault => 'System default';

  @override
  String offlineBanner(String time) {
    return 'Showing saved data from $time';
  }

  @override
  String get forecastHourly => 'Next 24 hours';

  @override
  String get forecastDaily => '7-day forecast';

  @override
  String get today => 'Today';

  @override
  String get now => 'Now';

  @override
  String get details => 'Details';

  @override
  String get sunTitle => 'Sunrise and sunset';

  @override
  String get uvLow => 'Low';

  @override
  String get uvModerate => 'Moderate';

  @override
  String get uvHigh => 'High';

  @override
  String get uvVeryHigh => 'Very high';

  @override
  String get uvExtreme => 'Extreme';

  @override
  String get privacyPolicy => 'Privacy Policy';
}
