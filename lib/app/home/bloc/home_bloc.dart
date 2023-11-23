import 'package:bloc/bloc.dart';
import 'package:breedy/app/bloc/app_bloc.dart';
import 'package:breedy/domain/models/breed.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(AppBloc appBloc) : super(HomeState()) {
    on<SwipeDialogUp>((event, emit) {
      emit(SearchDialogLarge());
    });

    on<SwipeDialogDown>((event, emit) async {
      emit(SearchDialogSmall());
    });

    on<BreedSearchEvent>((event, emit) async {
      final searchResult = appBloc.breedList
          .where((element) => element.breedName.contains(event.keyword))
          .toList();
      if (searchResult.isNotEmpty) {
        emit(BreedSearchSubmitted(searchResult));
      } else {
        emit(BreedSearchNotFound());
      }
    });
  }
}
