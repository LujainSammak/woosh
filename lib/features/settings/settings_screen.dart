import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/sky_palette.dart';
import '../../domain/settings.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/settings_provider.dart';

const _privacyUrl = 'https://sites.google.com/view/woosh-privacy';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final palette = SkyPalette.of(context);
    final s = ref.watch(settingsProvider).value ?? const Settings();
    final n = ref.read(settingsProvider.notifier);
    final label = Theme.of(context).textTheme.titleMedium;

    return Scaffold(
      backgroundColor: palette.sheet,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: palette.ink,
        title: Text(t.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(t.temperatureUnit, style: label),
          const SizedBox(height: 8),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('°C')),
              ButtonSegment(value: true, label: Text('°F')),
            ],
            selected: {s.fahrenheit},
            onSelectionChanged: (v) => n.setFahrenheit(v.first),
          ),
          const SizedBox(height: 24),
          Text(t.windUnit, style: label),
          const SizedBox(height: 8),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('km/h')),
              ButtonSegment(value: true, label: Text('mph')),
            ],
            selected: {s.mph},
            onSelectionChanged: (v) => n.setMph(v.first),
          ),
          const SizedBox(height: 24),
          Text(t.language, style: label),
          const SizedBox(height: 8),
          DropdownButton<String>(
            isExpanded: true,
            value: s.lang ?? '',
            items: [
              DropdownMenuItem(value: '', child: Text(t.systemDefault)),
              const DropdownMenuItem(value: 'en', child: Text('English')),
              const DropdownMenuItem(value: 'ar', child: Text('العربية')),
              const DropdownMenuItem(value: 'tr', child: Text('Türkçe')),
            ],
            onChanged: (v) {
              if (v != null) n.setLang(v.isEmpty ? null : v);
            },
          ),
          const SizedBox(height: 24),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.privacy_tip_outlined, color: palette.ink),
            title: Text(t.privacyPolicy),
            onTap: () => launchUrl(
              Uri.parse(_privacyUrl),
              mode: LaunchMode.externalApplication,
            ),
          ),
        ],
      ),
    );
  }
}