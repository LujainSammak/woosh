import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:woosh/data/geocoding_service.dart';

void main() {
  test('parses results and skips invalid entries', () async {
    final client = MockClient((req) async {
      expect(req.url.host, 'geocoding-api.open-meteo.com');
      expect(req.url.queryParameters['name'], 'Istanbul');
      return http.Response(
        '{"results":['
        '{"name":"Istanbul","admin1":"Istanbul","country":"Turkey","latitude":41.01,"longitude":28.95},'
        '{"name":"Bad","latitude":999,"longitude":10},'
        '{"latitude":1,"longitude":2}'
        ']}',
        200,
      );
    });
    final r = await GeocodingService(client: client).search('Istanbul', 'en');
    expect(r.length, 1);
    expect(r.first.label, 'Istanbul, Turkey');
    expect(r.first.lat, 41.01);
  });

  test('no results key gives an empty list', () async {
    final client = MockClient((req) async => http.Response('{}', 200));
    final r = await GeocodingService(client: client).search('zzzzzz', 'en');
    expect(r, isEmpty);
  });

  test('query shorter than 2 characters makes no request', () async {
    final client = MockClient((req) async => throw StateError('called'));
    final r = await GeocodingService(client: client).search(' a ', 'en');
    expect(r, isEmpty);
  });

  test('server error throws', () async {
    final client = MockClient((req) async => http.Response('', 500));
    expect(GeocodingService(client: client).search('Istanbul', 'en'),
        throwsException);
  });
}