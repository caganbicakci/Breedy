import 'dart:convert';
import 'package:breedy/domain/models/breed.dart';
import 'package:breedy/domain/models/breed_image.dart';
import 'package:breedy/domain/models/breed_list.dart';
import 'package:http/http.dart' as http;

class BreedRepository {
  Future<List<Breed>?> fetchAllBreeds() async {
    const allBreedsEndpoint = 'https://dog.ceo/api/breeds/list/all';
    final response = await http.get(Uri.parse(allBreedsEndpoint));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map;
      final breedListResponse = BreedListResponse.fromJson(data);

      final listOfBreeds = breedListResponse.message.entries
          .map((MapEntry<String, dynamic> entry) {
        final breedName = entry.key;
        final subBreeds = List<String>.from(entry.value as List<dynamic>);
        return Breed(breedName: breedName, subBreeds: subBreeds);
      }).toList();
      return listOfBreeds;
    } else {
      return null;
    }
  }

  Future<BreedImage?> getBreedImage(String breedName) async {
    final imageEndpoint = 'https://dog.ceo/api/breed/$breedName/images/random';
    final response = await http.get(Uri.parse(imageEndpoint));
    if (response.statusCode == 200) {
      final imageData = json.decode(response.body);
      final breedImage = BreedImage.fromJson(imageData);
      return breedImage;
    } else {
      return null;
    }
  }
}