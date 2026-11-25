import '../../domain/models/crate.dart';
import '../../domain/repositories/crates_repository.dart';

class MockCratesRepository implements CratesRepository {
  @override
  Future<List<Crate>> getCrates() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Имитация сети
    return List.generate(25, (index) => Crate(
      id: 'crate_$index',
      version: '1.0.$index',
      description: 'Описание для пакета crate_$index',
      downloads: 10000 * index,
    ));
  }

  @override
  Future<Crate> getCrateById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Crate(
      id: id,
      version: '2.0.0',
      description: 'Подробное описание для $id',
      downloads: 999999,
    );
  }
}
