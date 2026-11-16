import 'package:crates_catalog/data/cache.dart';
import 'package:crates_catalog/data/crates_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _searchJson = '''
{"crates":[
  {"id":"serde","name":"serde","max_version":"1.0.228","description":"A framework","downloads":123,
   "repository":"https://github.com/serde-rs/serde","documentation":null,"homepage":null,"unknown_field":1},
  {"id":"tokio","name":"tokio","max_version":"1.47.1","description":null,"downloads":456}
],"meta":{"total":2}}
''';

const _jsonHeaders = {'content-type': 'application/json'};

CratesApi _api(Future<http.Response> Function(http.Request request) handler) =>
    CratesApi(client: createCratesClient(MockClient(handler)), cache: Cache());

void main() {
  test('parses a search response', () async {
    final api = _api((_) async => http.Response(_searchJson, 200, headers: _jsonHeaders));
    final crates = await api.search('serde', 1, 20);
    expect(crates.map((c) => c.name), ['serde', 'tokio']);
    expect(crates[0].version, '1.0.228');
    expect(crates[0].downloads, 123);
    expect(crates[1].description, isNull);
  });

  test('sends the User-Agent header on every request', () async {
    final seen = <String?>[];
    final api = _api((request) async {
      seen.add(request.headers['user-agent']);
      return http.Response(_searchJson, 200, headers: _jsonHeaders);
    });
    await api.search('serde', 1, 20);
    await api.search('tokio', 2, 20);
    expect(seen, hasLength(2));
    expect(seen, everyElement(CratesApi.userAgent));
  });

  test('sends query and paging parameters (per_page clamped to 100)', () async {
    late Uri uri;
    final api = _api((request) async {
      uri = request.url;
      return http.Response(_searchJson, 200, headers: _jsonHeaders);
    });
    await api.search('serde', 3, 500);
    expect(uri.queryParameters['q'], 'serde');
    expect(uri.queryParameters['page'], '3');
    expect(uri.queryParameters['per_page'], '100');
  });

  test('maps 404 / 429 / 500 / garbage to typed errors', () async {
    expect(_api((_) async => http.Response('', 404)).getCrate('nope'), throwsA(isA<NotFoundError>()));
    expect(_api((_) async => http.Response('', 429)).search('x', 1), throwsA(isA<RateLimitedError>()));
    expect(_api((_) async => http.Response('', 500)).search('x', 1), throwsA(isA<HttpError>()));
    expect(_api((_) async => http.Response('not json', 200)).search('x', 1), throwsA(isA<ParseError>()));
  });

  test('network failure becomes NetworkError', () async {
    final api = _api((_) async => throw http.ClientException('offline'));
    expect(api.search('x', 1), throwsA(isA<NetworkError>()));
  });

  test('getCrate combines crate, owners and dependencies', () async {
    final api = _api((request) async {
      final path = request.url.path;
      final String body;
      if (path.endsWith('/owners')) {
        body = '{"users":[{"id":1,"login":"dtolnay","name":"David Tolnay","avatar":"https://example.com/a.png"}]}';
      } else if (path.endsWith('/dependencies')) {
        body = '{"dependencies":[{"crate_id":"serde_derive","kind":"normal"},{"crate_id":"serde_core","kind":"normal"}]}';
      } else {
        body = '{"crate":{"name":"serde","max_version":"1.0.228","description":"d","downloads":9},'
            '"versions":[{"num":"1.0.228","downloads":5,"created_at":"2025-09-01T00:00:00Z"}]}';
      }
      return http.Response(body, 200, headers: _jsonHeaders);
    });
    final detail = await api.getCrate('serde');
    expect(detail.crate.name, 'serde');
    expect(detail.dependencies, ['serde_derive', 'serde_core']);
    expect(detail.crate.owners, ['dtolnay']);
    expect(detail.owners.single.name, 'David Tolnay');
    expect(detail.versions.single.number, '1.0.228');
  });
}
