part of 'home_bloc.dart';

class HomeState {}

final class HomeInitial extends HomeState {}

class BreedsLoading extends HomeState {}

class BreedsLoaded extends HomeState {
  BreedsLoaded(this.breeds);
  List<Breed>? breeds;
}

class BreedsLoadError extends HomeState {}
