import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState()) {
    on<SwipeDialogUp>((event, emit) => emit(SearchDialogLarge()));
    on<SwipeDialogDown>((event, emit) => emit(SearchDialogSmall()));
  }
}
