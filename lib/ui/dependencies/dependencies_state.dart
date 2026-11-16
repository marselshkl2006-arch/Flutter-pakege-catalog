import '../../data/crates_repository.dart';
import '../../state/safe_notifier.dart';

class DependenciesState extends SafeNotifier {
  List<String> dependencies = const [];
  bool isLoading = false;
  String? error;

  Future<void> load(CratesRepository repository, String crateName) async {
    isLoading = true;
    error = null;
    notifyListeners();
    (await repository.getDependencies(crateName)).when(
      success: (list) => dependencies = list,
      failure: (e) => error = e.toString(),
    );
    isLoading = false;
    notifyListeners();
  }
}
