import 'dart:convert';
import 'package:breedy/domain/models/breed.dart';
import 'package:breedy/domain/models/breed_image.dart';
import 'package:breedy/domain/models/breed_list.dart';
import 'package:http/http.dart' as http;

class BreedRepository {
  final _apiUrl = 'https://dog.ceo/api/breeds/list/all';
  final List<String> listOfBreed = List.empty();

  Future<List<String>?> getAllBreedsFromApi() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map;
        final breeds = BreedListResponse.fromJson(data);

        if (breeds.status == 'success') {
          return breeds.message.keys.toList();
        } else {
          return null;
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<http.Response> getBreedImage(String breed) async {
    return http
        .get(Uri.parse('https://dog.ceo/api/breed/$breed/images/random'));
  }

  Future<List<Breed>?> getBreeds() async {
    final breedList = List<Breed>.empty(growable: true);
    try {
      final allBreeds = await getAllBreedsFromApi();
      if (allBreeds != null) {
        for (final breed in allBreeds.sublist(0, 4)) {
          final imageResponse = await getBreedImage(breed);
          if (imageResponse.statusCode == 200) {
            final imageData = json.decode(imageResponse.body);
            final breedImage = BreedImage.fromJson(imageData);
            final breedImageUrl = breedImage.message;
            breedList
                .add(Breed(breedName: breed, bredeImageUrl: breedImageUrl));
          }
        }
        return breedList.sublist(0, 4);
      }
    } catch (e) {
      print(e);
    }
  }
}
