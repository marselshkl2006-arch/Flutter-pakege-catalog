import '../../data/crates_api.dart';
import '../../data/crates_repository.dart';
import '../../model/crate.dart';
import '../../state/safe_notifier.dart';

/// Case-insensitive match on name or description; a blank query keeps everything.
List<Crate> filterByQuery(List<Crate> crates, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return crates;
  return crates
      .where((c) => c.name.toLowerCase().contains(q) || (c.description ?? '').toLowerCase().contains(q))
      .toList();
}

class ListState extends SafeNotifier {
  List<Crate> _crates = const [];
  String _query = '';
  int _page = 1;
  bool _isLoading = false;
  bool _endReached = false;
  String? _error;

  // Invalidates in-flight requests when a new first-page load starts.
  int _generation = 0;

  List<Crate> get crates => _crates;
  String get query => _query;
  int get page => _page;
  bool get isLoading => _isLoading;
  bool get endReached => _endReached;
  String? get error => _error;

  List<Crate> get filtered => filterByQuery(_crates, _query);

  /// Test/seed helper.
  set crates(List<Crate> value) {
    _crates = value;
    notifyListeners();
  }

  set query(String value) {
    if (value == _query) return;
    _query = value;
    notifyListeners();
  }

  Future<void> loadFirstPage(CratesRepository repository) async {
    final gen = ++_generation;
    _crates = const [];
    _page = 1;
    _endReached = false;
    _error = null;
    _isLoading = true;
    notifyListeners();

    final result = await repository.search(_query, 1, defaultPerPage);
    if (gen != _generation) return;
    result.when(
      success: (list) {
        _crates = _dedupe(list);
        _endReached = list.length < defaultPerPage;
      },
      failure: (e) => _error = e.toString(),
    );
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadNextPage(CratesRepository repository) async {
    if (_isLoading || _endReached || _error != null) return;
    final gen = _generation;
    final next = _page + 1;
    _isLoading = true;
    notifyListeners();

    final result = await repository.search(_query, next, defaultPerPage);
    if (gen != _generation) return;
    result.when(
      success: (list) {
        _crates = _dedupe([..._crates, ...list]);
        _page = next;
        _endReached = list.length < defaultPerPage;
      },
      failure: (e) => _error = e.toString(),
    );
    _isLoading = false;
    notifyListeners();
  }

  List<Crate> _dedupe(List<Crate> list) {
    final seen = <String>{};
    return [
      for (final c in list)
        if (seen.add(c.name)) c,
    ];
  }
}
