import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/place.dart';

/// The user's saved cities, kept on the phone.
class Favorites extends AsyncNotifier<List<Place>> {
  static const _k = 'favorite_places';
  static const maxItems = 20;

  @override
  Future<List<Place>> build() async {
    try {
      final p = await SharedPreferences.getInstance();
      final raw = p.getString(_k);
      if (raw == null) return const [];
      final list = jsonDecode(raw);
      if (list is! List) return const [];
      return list.map(Place.fromJson).whereType<Place>().toList();
    } catch (_) {
      return const [];
    }
  }

  Future<void> _save(List<Place> v) async {
    state = AsyncData(v);
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString(_k, jsonEncode([for (final x in v) x.toJson()]));
    } catch (_) {}
  }

  Future<void> add(Place place) async {
    final cur = state.value ?? const <Place>[];
    if (cur.any((x) => x.key == place.key)) return;
    await _save([place, ...cur].take(maxItems).toList());
  }

  Future<void> remove(Place place) async {
    final cur = state.value ?? const <Place>[];
    await _save(cur.where((x) => x.key != place.key).toList());
  }
}

final favoritesProvider =
    AsyncNotifierProvider<Favorites, List<Place>>(Favorites.new);