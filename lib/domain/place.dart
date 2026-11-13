class Place {
  final String label;
  final double lat;
  final double lon;
  const Place({required this.label, required this.lat, required this.lon});

  static bool validCoords(double lat, double lon) =>
      lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180;

  /// Same city = same coordinates to about 1 km.
  String get key => '${lat.toStringAsFixed(2)},${lon.toStringAsFixed(2)}';

  Map<String, dynamic> toJson() => {'label': label, 'lat': lat, 'lon': lon};

  static Place? fromJson(Object? j) {
    if (j is! Map) return null;
    final label = j['label'];
    final lat = j['lat'];
    final lon = j['lon'];
    if (label is! String || lat is! num || lon is! num) return null;
    if (!validCoords(lat.toDouble(), lon.toDouble())) return null;
    return Place(label: label, lat: lat.toDouble(), lon: lon.toDouble());
  }
}