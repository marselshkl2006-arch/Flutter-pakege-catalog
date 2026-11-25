import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/crates_repository.dart';
import 'list_state.dart';

class ListCubit extends Cubit<ListState> {
  final CratesRepository repository;

  ListCubit(this.repository) : super(ListLoading()) {
    loadCrates();
  }

  Future<void> loadCrates() async {
    emit(ListLoading());
    try {
      final crates = await repository.getCrates();
      emit(ListLoaded(crates: crates, filteredCrates: crates, query: ''));
    } catch (e) {
      emit(ListError());
    }
  }

  void search(String query) {
    final currentState = state;
    if (currentState is ListLoaded) {
      if (query.isEmpty) {
        emit(ListLoaded(crates: currentState.crates, filteredCrates: currentState.crates, query: ''));
      } else {
        final filtered = currentState.crates
            .where((c) => c.id.toLowerCase().contains(query.toLowerCase()))
            .toList();
        emit(ListLoaded(crates: currentState.crates, filteredCrates: filtered, query: query));
      }
    }
  }
}
