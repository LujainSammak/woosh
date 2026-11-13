import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/weather_provider.dart';
import '../search/search_screen.dart';

class ErrorView extends ConsumerWidget {
  final WeatherError error;
  const ErrorView({super.key, required this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final msg = switch (error) {
      WeatherError.locationOff => t.errLocationOff,
      WeatherError.locationDenied => t.errLocationDenied,
      WeatherError.locationForever => t.errLocationForever,
      WeatherError.network => t.errNetwork,
      WeatherError.data => t.errData,
    };
    // City search needs internet, so only offer it for location problems.
    final canSearch = error == WeatherError.locationOff ||
        error == WeatherError.locationDenied ||
        error == WeatherError.locationForever;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 56),
            const SizedBox(height: 16),
            Text(msg,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => ref.invalidate(weatherProvider),
              child: Text(t.retry),
            ),
            if (canSearch) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.search),
                label: Text(t.searchCity),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}