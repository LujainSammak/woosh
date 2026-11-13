import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'domain/settings.dart';
import 'features/home/home_screen.dart';
import 'l10n/app_localizations.dart';
import 'providers/settings_provider.dart';
import 'providers/weather_provider.dart';

class WooshApp extends ConsumerWidget {
  const WooshApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phase = ref.watch(skyPhaseProvider);
    final settings = ref.watch(settingsProvider).value ?? const Settings();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (c) => AppLocalizations.of(c).appTitle,
      theme: themeFor(phase),
      themeAnimationDuration: const Duration(milliseconds: 700),
      locale: settings.lang == null ? null : Locale(settings.lang!),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomeScreen(),
    );
  }
}