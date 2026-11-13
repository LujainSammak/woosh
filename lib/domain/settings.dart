const supportedLangs = ['en', 'ar', 'tr'];

class Settings {
  final bool fahrenheit;
  final bool mph;
  final String? lang; // null = follow the phone's language

  const Settings({this.fahrenheit = false, this.mph = false, this.lang});

  Settings copyWith({bool? fahrenheit, bool? mph}) => Settings(
        fahrenheit: fahrenheit ?? this.fahrenheit,
        mph: mph ?? this.mph,
        lang: lang,
      );

  Settings withLang(String? l) =>
      Settings(fahrenheit: fahrenheit, mph: mph, lang: l);

  /// Input is always Celsius (what the API returns).
  String temp(double c) {
    final v = fahrenheit ? c * 9 / 5 + 32 : c;
    return '${v.round()}°';
  }

  /// Input is always km/h (what the API returns).
  String wind(double kmh) =>
      mph ? '${(kmh / 1.609344).round()} mph' : '${kmh.round()} km/h';
}