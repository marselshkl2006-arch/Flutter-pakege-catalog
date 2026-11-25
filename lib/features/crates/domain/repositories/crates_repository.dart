import '../models/crate.dart';

abstract class CratesRepository {
  Future<List<Crate>> getCrates();
  Future<Crate> getCrateById(String id);
}
