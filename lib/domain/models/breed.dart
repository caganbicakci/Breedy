class Breed {
  Breed({
    required this.breedName,
    this.breedImageUrl,
    this.subBreeds,
  });

  String breedName;
  String? breedImageUrl;
  List<String>? subBreeds;
}
