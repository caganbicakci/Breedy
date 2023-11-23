part of 'home_bloc.dart';

class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SwipeDialogUp extends HomeEvent {}

class SwipeDialogDown extends HomeEvent {}

class BreedSearchEvent extends HomeEvent {
  BreedSearchEvent(this.keyword);
  final String keyword;

  @override
  List<Object?> get props => [];
}
