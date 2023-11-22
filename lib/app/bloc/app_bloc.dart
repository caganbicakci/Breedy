import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:breedy/domain/models/breed.dart';
import 'package:breedy/domain/repository/breed_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial()) {
    on<BreedsLoadEvent>((event, emit) async {
      emit(BreedsLoading());
      await fetchAllBreeds();
      final breedList = await _breedFetcher.stream.first;
      Logger().i(breedList);
      emit(BreedsLoaded(breedList));
    });
  }

  Future<void> fetchAllBreeds() async {
    _breedRepository.fetchAllBreeds().listen((value) {
      if (!_breedFetcher.isClosed) {
        _breedFetcher.sink.add(value);
      }
    });
  }

  void dispose() {
    _breedFetcher.close();
  }

  final _breedFetcher = StreamController<List<Breed>>();
  Stream<List<Breed>> get breedStream => _breedFetcher.stream;
  final _breedRepository = BreedRepository();
}
