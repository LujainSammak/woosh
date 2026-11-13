import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/sky_palette.dart';
import '../../data/geocoding_service.dart';
import '../../domain/place.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/favorites.dart';
import '../../providers/location_choice.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  static const _gold = Color(0xFFF2B01E);

  final _controller = TextEditingController();
  final _service = GeocodingService();
  Timer? _debounce;
  int _seq = 0; // ignores slow, outdated responses
  List<Place> _results = const [];
  bool _loading = false;
  bool _failed = false;
  bool _searched = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String v) {
    _debounce?.cancel();
    if (v.trim().length < 2) {
      _seq++;
      setState(() {
        _results = const [];
        _loading = false;
        _failed = false;
        _searched = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () => _run(v));
  }

  Future<void> _run(String q) async {
    final id = ++_seq;
    setState(() {
      _loading = true;
      _failed = false;
    });
    final lang = Localizations.localeOf(context).languageCode;
    try {
      final r = await _service.search(q, lang);
      if (!mounted || id != _seq) return;
      setState(() {
        _results = r;
        _loading = false;
        _searched = true;
      });
    } catch (_) {
      if (!mounted || id != _seq) return;
      setState(() {
        _results = const [];
        _loading = false;
        _failed = true;
        _searched = true;
      });
    }
  }

  Future<void> _pick(Place p) async {
    await ref.read(choiceProvider.notifier).select(p);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _useGps() async {
    await ref.read(choiceProvider.notifier).useGps();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final palette = SkyPalette.of(context);
    final favs = ref.watch(favoritesProvider).value ?? const <Place>[];
    final current = ref.watch(choiceProvider).value;
    final favNotifier = ref.read(favoritesProvider.notifier);

    bool isFav(Place p) => favs.any((x) => x.key == p.key);

    Widget content;
    if (_loading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (_failed) {
      content = Center(child: Text(t.errNetwork, textAlign: TextAlign.center));
    } else if (_searched && _results.isEmpty) {
      content = Center(child: Text(t.noResults));
    } else if (!_searched) {
      // Nothing typed yet: show "use my location" and the saved cities.
      content = ListView(
        children: [
          if (current != null)
            ListTile(
              leading: const Icon(Icons.my_location),
              title: Text(t.useMyLocation),
              onTap: _useGps,
            ),
          for (final f in favs)
            ListTile(
              leading: const Icon(Icons.star_rounded, color: _gold),
              title: Text(f.label),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => favNotifier.remove(f),
              ),
              onTap: () => _pick(f),
            ),
        ],
      );
    } else {
      content = ListView.builder(
        itemCount: _results.length,
        itemBuilder: (_, i) {
          final place = _results[i];
          final fav = isFav(place);
          return ListTile(
            leading: const Icon(Icons.location_city),
            title: Text(place.label),
            trailing: IconButton(
              icon: Icon(
                fav ? Icons.star_rounded : Icons.star_border_rounded,
                color: fav ? _gold : null,
              ),
              onPressed: () =>
                  fav ? favNotifier.remove(place) : favNotifier.add(place),
            ),
            onTap: () => _pick(place),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: palette.sheet,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: palette.ink,
        title: Text(t.searchCity),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              maxLength: 60,
              textInputAction: TextInputAction.search,
              onChanged: _onChanged,
              decoration: InputDecoration(
                hintText: t.searchHint,
                prefixIcon: const Icon(Icons.search),
                counterText: '',
                filled: true,
                fillColor: palette.hairline,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }
}