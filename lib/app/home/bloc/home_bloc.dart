import 'package:bloc/bloc.dart';
import 'package:breedy/domain/models/breed.dart';
import 'package:breedy/domain/repository/breed_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<BreedLoadEvent>((event, emit) async {
      try {
        emit(BreedsLoading());
        final result = await breedRepository.getBreeds();
        if (result != null) {
          emit(BreedsLoaded(result.sublist(0, 4)));
        }
      } catch (exception) {
        emit(BreedsLoadError());
      }
    });
  }
  final breedRepository = BreedRepository();
}
