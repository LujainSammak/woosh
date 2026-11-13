import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/place.dart';

class GeocodingService {
  GeocodingService({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  Future<List<Place>> search(String query, String lang) async {
    final q = query.trim();
    if (q.length < 2) return const [];

    final uri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
      'name': q.length > 60 ? q.substring(0, 60) : q,
      'count': '8',
      'language': lang,
      'format': 'json',
    });

    final res = await _client.get(uri).timeout(const Duration(seconds: 10));
    if (res.statusCode != 200) {
      throw Exception('Geocoding failed: ${res.statusCode}');
    }

    final json = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    final list = json['results'];
    if (list is! List) return const [];

    final out = <Place>[];
    for (final e in list) {
      if (e is! Map<String, dynamic>) continue;
      final name = e['name'];
      final lat = e['latitude'];
      final lon = e['longitude'];
      if (name is! String || lat is! num || lon is! num) continue;
      if (!Place.validCoords(lat.toDouble(), lon.toDouble())) continue;

      final parts = <String>[name];
      final admin = e['admin1'];
      if (admin is String && admin.isNotEmpty && admin != name) parts.add(admin);
      final country = e['country'];
      if (country is String && country.isNotEmpty) parts.add(country);

      out.add(Place(
        label: parts.join(', '),
        lat: lat.toDouble(),
        lon: lon.toDouble(),
      ));
    }
    return out;
  }
}