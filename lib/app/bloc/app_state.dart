part of 'app_bloc.dart';

@immutable
class AppState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppInitial extends AppState {}

class BreedsLoading extends AppState {}

class BreedsLoaded extends AppState {
  BreedsLoaded(this.breeds);
  final List<Breed>? breeds;
}

class BreedsLoadError extends AppState {}
