import '../../data/crates_repository.dart';
import '../../model/owner.dart';
import '../../state/safe_notifier.dart';

class OwnerState extends SafeNotifier {
  Owner? owner;
  bool isLoading = false;
  String? error;

  Future<void> load(CratesRepository repository, String login) async {
    isLoading = true;
    error = null;
    notifyListeners();
    (await repository.getOwner(login)).when(
      success: (o) => owner = o,
      failure: (e) => error = e.toString(),
    );
    isLoading = false;
    notifyListeners();
  }
}
