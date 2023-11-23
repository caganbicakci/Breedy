part of 'home_bloc.dart';

class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class SearchDialogInitial extends HomeState {}

class SearchDialogSmall extends HomeState {}

class SearchDialogLarge extends HomeState {}

class BreedSearchSubmitted extends HomeState {
  BreedSearchSubmitted(this.breedSearchResult);
  final List<Breed> breedSearchResult;

  @override
  List<Object?> get props => [];
}

class BreedSearchNotFound extends HomeState {}
