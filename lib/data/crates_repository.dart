import '../model/crate.dart';
import '../model/crate_detail.dart';
import '../model/owner.dart';
import 'crates_api.dart';
import 'mock_data.dart';

sealed class ApiResult<T> {
  const ApiResult();

  R when<R>({required R Function(T value) success, required R Function(Object error) failure}) => switch (this) {
        Success<T>(:final value) => success(value),
        Failure<T>(:final error) => failure(error),
      };
}

final class Success<T> extends ApiResult<T> {
  const Success(this.value);
  final T value;
}

final class Failure<T> extends ApiResult<T> {
  const Failure(this.error);
  final Object error;
}

/// Layer between the data sources and the UI. Every method returns an [ApiResult].
/// [useMocks] is read on every call, so flipping the flag switches mock <-> network at runtime
/// without touching any UI code.
class CratesRepository {
  CratesRepository({required this.api, CratesDataSource? mock, required this.useMocks})
      : mock = mock ?? MockCratesSource();

  final CratesDataSource api;
  final CratesDataSource mock;
  final bool Function() useMocks;
  final Map<String, Owner> _knownOwners = {};

  CratesDataSource get _source => useMocks() ? mock : api;

  Future<ApiResult<List<Crate>>> search(String query, int page, [int perPage = defaultPerPage]) =>
      _call(() => _source.search(query, page, perPage));

  Future<ApiResult<CrateDetail>> getCrate(String name) => _call(() async {
        final detail = await _source.getCrate(name);
        for (final o in detail.owners) {
          _knownOwners[o.login] = o;
        }
        return detail;
      });

  Future<ApiResult<List<String>>> getDependencies(String name) => _call(() => _source.getDependencies(name));

  Future<ApiResult<List<Owner>>> getOwners(String name) => _call(() async {
        final owners = await _source.getOwners(name);
        for (final o in owners) {
          _knownOwners[o.login] = o;
        }
        return owners;
      });

  Future<ApiResult<Owner>> getOwner(String login) => _call(() async {
        final known = _knownOwners[login];
        if (known != null) return known;
        final owner = await _source.getUser(login);
        _knownOwners[login] = owner;
        return owner;
      });

  Future<ApiResult<T>> _call<T>(Future<T> Function() block) async {
    try {
      return Success(await block());
    } catch (e) {
      return Failure(e);
    }
  }
}
