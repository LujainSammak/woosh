import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/settings.dart';

class SettingsNotifier extends AsyncNotifier<Settings> {
  static const _kF = 'fahrenheit';
  static const _kMph = 'mph';
  static const _kLang = 'lang';

  @override
  Future<Settings> build() async {
    final p = await SharedPreferences.getInstance();
    final lang = p.getString(_kLang);
    return Settings(
      fahrenheit: p.getBool(_kF) ?? false,
      mph: p.getBool(_kMph) ?? false,
      lang: supportedLangs.contains(lang) ? lang : null,
    );
  }

  Settings get _now => state.value ?? const Settings();

  Future<void> _save(Settings s) async {
    state = AsyncData(s);
    try {
      final p = await SharedPreferences.getInstance();
      await p.setBool(_kF, s.fahrenheit);
      await p.setBool(_kMph, s.mph);
      if (s.lang == null) {
        await p.remove(_kLang);
      } else {
        await p.setString(_kLang, s.lang!);
      }
    } catch (_) {}
  }

  Future<void> setFahrenheit(bool v) => _save(_now.copyWith(fahrenheit: v));
  Future<void> setMph(bool v) => _save(_now.copyWith(mph: v));
  Future<void> setLang(String? l) => _save(_now.withLang(l));
}

final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, Settings>(SettingsNotifier.new);