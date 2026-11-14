import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/crate.dart';
import '../model/crate_detail.dart';
import '../model/crate_version.dart';
import '../model/owner.dart';
import 'cache.dart';

const int defaultPerPage = 20;

/// crates.io caps `per_page` at 100 (not 10000). Adjust here if the API changes.
const int maxPerPage = 100;

sealed class ApiError implements Exception {
  const ApiError(this.message);
  final String message;

  @override
  String toString() => message;
}

final class NetworkError extends ApiError {
  NetworkError([Object? cause]) : super('Network error${cause == null ? '' : ': $cause'}');
}

final class TimeoutError extends ApiError {
  TimeoutError() : super('Request timed out');
}

final class NotFoundError extends ApiError {
  NotFoundError(this.what) : super('Not found: $what');
  final String what;
}

final class RateLimitedError extends ApiError {
  RateLimitedError([this.retryAfterSeconds])
      : super('Too many requests (HTTP 429)${retryAfterSeconds == null ? '' : ', retry after ${retryAfterSeconds}s'}');
  final int? retryAfterSeconds;
}

final class HttpError extends ApiError {
  HttpError(this.code) : super('Server returned HTTP $code');
  final int code;
}

final class ParseError extends ApiError {
  ParseError([Object? cause]) : super('Unexpected response format');
}

/// What the repository needs from a data source: the real API or the hand-written mocks.
abstract interface class CratesDataSource {
  Future<List<Crate>> search(String query, int page, [int perPage = defaultPerPage]);
  Future<CrateDetail> getCrate(String name);
  Future<List<String>> getDependencies(String name);
  Future<List<Owner>> getOwners(String name);
  Future<Owner> getUser(String login);
}

/// Adds the mandatory User-Agent header to every request.
/// (Browsers ignore this header; on Web the real API may also be blocked by CORS.)
class UserAgentClient extends http.BaseClient {
  UserAgentClient(this._inner);
  final http.Client _inner;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['User-Agent'] = CratesApi.userAgent;
    return _inner.send(request);
  }

  @override
  void close() => _inner.close();
}

http.Client createCratesClient([http.Client? inner]) => UserAgentClient(inner ?? http.Client());

class CratesApi implements CratesDataSource {
  CratesApi({
    required http.Client client,
    Cache? cache,
    this.baseUrl = defaultBaseUrl,
    this.usersUrl = defaultUsersUrl,
    this.timeout = const Duration(seconds: 15),
  })  : _client = client,
        _cache = cache ?? Cache();

  static const String userAgent = 'MyCatalog/1.0 (me@example.com)';
  static const String apiRoot = 'https://crates.io/api/v1';
  static const String defaultBaseUrl = '$apiRoot/crates';
  static const String defaultUsersUrl = '$apiRoot/users';

  final http.Client _client;
  final Cache _cache;
  final String baseUrl;
  final String usersUrl;
  final Duration timeout;

  @override
  Future<List<Crate>> search(String query, int page, [int perPage = defaultPerPage]) async {
    final q = query.trim();
    final uri = _uri(baseUrl, const [], {
      if (q.isNotEmpty) 'q': q else 'sort': 'downloads',
      'page': '${page < 1 ? 1 : page}',
      'per_page': '${perPage.clamp(1, maxPerPage)}',
    });
    final text = await _fetch(uri, 'search');
    return _parse(text, (j) => (j['crates'] as List).map((e) => Crate.fromJson(e as Map<String, dynamic>)).toList());
  }

  @override
  Future<CrateDetail> getCrate(String name) async {
    final fetched = await _fetchCrate(name);
    final owners = await getOwners(name);
    final dependencies = await getDependencies(name);
    return CrateDetail(
      crate: fetched.crate.copyWith(dependencies: dependencies, owners: owners.map((o) => o.login).toList()),
      versions: fetched.versions,
      owners: owners,
      dependencies: dependencies,
    );
  }

  @override
  Future<List<String>> getDependencies(String name) async {
    final version = (await _fetchCrate(name)).crate.version;
    final text = await _fetch(_uri(baseUrl, [name, version, 'dependencies']), '$name dependencies');
    return _parse(
      text,
      (j) => (j['dependencies'] as List).map((e) => (e as Map<String, dynamic>)['crate_id'] as String).toSet().toList(),
    );
  }

  @override
  Future<List<Owner>> getOwners(String name) async {
    final text = await _fetch(_uri(baseUrl, [name, 'owners']), '$name owners');
    return _parse(text, (j) => (j['users'] as List).map((e) => Owner.fromJson(e as Map<String, dynamic>)).toList());
  }

  @override
  Future<Owner> getUser(String login) async {
    final text = await _fetch(_uri(usersUrl, [login]), login);
    return _parse(text, (j) => Owner.fromJson(j['user'] as Map<String, dynamic>));
  }

  void close() => _client.close();

  Future<({Crate crate, List<CrateVersion> versions})> _fetchCrate(String name) async {
    final text = await _fetch(_uri(baseUrl, [name]), name);
    return _parse(
      text,
      (j) => (
        crate: Crate.fromJson(j['crate'] as Map<String, dynamic>),
        versions: ((j['versions'] as List?) ?? const [])
            .map((e) => CrateVersion.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
    );
  }

  Uri _uri(String base, List<String> segments, [Map<String, String>? query]) {
    final b = Uri.parse(base);
    return b.replace(pathSegments: [...b.pathSegments, ...segments], queryParameters: query);
  }

  Future<String> _fetch(Uri uri, String what) async {
    final key = uri.toString();
    final cached = _cache.get(key);
    if (cached != null) return cached;

    final http.Response response;
    try {
      response = await _client.get(uri).timeout(timeout);
    } on TimeoutException {
      throw TimeoutError();
    } catch (e) {
      throw NetworkError(e);
    }

    final status = response.statusCode;
    if (status == 404) throw NotFoundError(what);
    if (status == 429) throw RateLimitedError(int.tryParse(response.headers['retry-after'] ?? ''));
    if (status < 200 || status >= 300) throw HttpError(status);

    // crates.io sends JSON without a charset: decode as UTF-8 explicitly.
    final body = utf8.decode(response.bodyBytes);
    _cache.put(key, body);
    return body;
  }

  T _parse<T>(String text, T Function(Map<String, dynamic> json) parse) {
    try {
      return parse(jsonDecode(text) as Map<String, dynamic>);
    } catch (e) {
      throw ParseError(e);
    }
  }
}
