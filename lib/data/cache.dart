/// Simple in-memory cache of raw response bodies, keyed by request URL. Nothing is persisted.
class Cache {
  final Map<String, String> _map = {};

  String? get(String key) => _map[key];

  void put(String key, String value) => _map[key] = value;
}
