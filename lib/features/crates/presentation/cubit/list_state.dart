import 'package:equatable/equatable.dart';
import '../../domain/models/crate.dart';

abstract class ListState extends Equatable {
  const ListState();
  @override
  List<Object> get props => [];
}

class ListLoading extends ListState {}
class ListError extends ListState {}

class ListLoaded extends ListState {
  final List<Crate> crates;
  final List<Crate> filteredCrates;
  final String query;

  const ListLoaded({
    required this.crates,
    required this.filteredCrates,
    required this.query,
  });

  @override
  List<Object> get props => [crates, filteredCrates, query];
}
