import '../../data/crates_repository.dart';
import '../../model/crate_detail.dart';
import '../../state/safe_notifier.dart';

class DetailState extends SafeNotifier {
  CrateDetail? crate;
  bool isLoading = false;
  String? error;

  Future<void> load(CratesRepository repository, String name) async {
    isLoading = true;
    error = null;
    notifyListeners();
    (await repository.getCrate(name)).when(
      success: (detail) => crate = detail,
      failure: (e) => error = e.toString(),
    );
    isLoading = false;
    notifyListeners();
  }
}
