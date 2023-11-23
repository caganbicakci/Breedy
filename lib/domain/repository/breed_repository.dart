import 'dart:convert';
import 'package:breedy/domain/models/breed.dart';
import 'package:breedy/domain/models/breed_list_response.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class BreedRepository {
  Stream<List<Breed>> fetchAllBreeds() async* {
    final breedList = <Breed>[];
    try {
      const allBreedsEndpoint = 'https://dog.ceo/api/breeds/list/all';
      final response = await http.get(Uri.parse(allBreedsEndpoint));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map;
        final breedListResponse = BreedListResponse.fromJson(data);

        for (final key in breedListResponse.message.keys) {
          final breedName = key;
          final subBreeds = List<String>.from(
            breedListResponse.message[key] as List<dynamic>,
          );
          final breedImageUrl = await getBreedImageUrl(breedName);
          final breed = Breed(
            breedName: breedName,
            subBreeds: subBreeds,
            breedImageUrl: breedImageUrl,
          );
          breedList.add(breed);
        }
        yield breedList;
      }
    } catch (exception) {
      Logger().e(exception);
    }
  }

  Future<String> getBreedImageUrl(String breedName) async {
    try {
      final imageEndpoint =
          'https://dog.ceo/api/breed/$breedName/images/random';
      final response = await http.get(Uri.parse(imageEndpoint));
      if (response.statusCode == 200) {
        final imageData = json.decode(response.body);
        return imageData['message'] as String;
      } else {
        return 'Na';
      }
    } catch (exception) {
      return 'Na';
    }
  }

  Future<bool> checkImageUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
