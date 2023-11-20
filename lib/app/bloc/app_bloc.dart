import 'package:bloc/bloc.dart';
import 'package:breedy/domain/models/breed.dart';
import 'package:breedy/domain/repository/breed_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial()) {
    on<BreedsLoadEvent>((event, emit) async {
      emit(BreedsLoading());
      final breeds = await _breedRepository.fetchAllBreeds();

      if (breeds != null) {
        for (final breed in breeds) {
          await getBreedImage(breed.breedName).then((value) {
            breed.breedImageUrl = value;
          });
        }
        emit(BreedsLoaded(breeds));
      }
    });
  }

  Future<String?> getBreedImage(String breedName) async {
    final breedImage = await _breedRepository.getBreedImage(breedName);
    if (breedImage != null) {
      final imageUrl = breedImage.message;
      return imageUrl;
    } else {
      return null;
    }
  }

  final _breedRepository = BreedRepository();
}
