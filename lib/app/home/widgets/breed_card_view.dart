import 'package:breedy/domain/models/breed.dart';
import 'package:breedy/domain/repository/breed_repository.dart';
import 'package:flutter/material.dart';

class BreedCardView extends StatelessWidget {
  BreedCardView({required this.breed, super.key});
  final Breed breed;
  final _breedRepo = BreedRepository();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showBreedDetailDialog(context),
      child: Stack(
        children: [
          Positioned.fill(
            child: buildBreedClip(),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: buildBreedTitle(),
          ),
        ],
      ),
    );
  }

  Container buildBreedTitle() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Center(
        child: Text(
          breed.breedName,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  ClipRRect buildBreedClip() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        breed.breedImageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, obj, stack) {
          return const Center(
            child: Icon(Icons.image_not_supported),
          );
        },
      ),
    );
  }

  void showBreedDetailDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: Builder(
            builder: (context) {
              final width = MediaQuery.of(context).size.width * 0.8;
              final height = MediaQuery.of(context).size.height * 0.7;
              return SizedBox(
                width: width,
                height: height,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: width,
                          width: width,
                          child: buildImageDetail(),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white,
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          buildBreedNameDetail(context),
                          buildSubBreedDetail(context),
                          buildGenerateButton(context),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  ClipRRect buildImageDetail() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
      child: Image.network(breed.breedImageUrl!, fit: BoxFit.cover,
          errorBuilder: (context, obj, stack) {
        return const Center(
          child: Icon(Icons.image_not_supported),
        );
      }),
    );
  }

  Column buildBreedNameDetail(BuildContext context) {
    return Column(
      children: [
        Text(
          'Breed',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: const Color(0xff0055D3),
              ),
        ),
        const Divider(),
        Text(breed.breedName),
      ],
    );
  }

  Column buildSubBreedDetail(BuildContext context) {
    return Column(
      children: [
        Text(
          'Sub Breed',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: const Color(0xff0055D3),
              ),
        ),
        const Divider(),
        SizedBox(
          height: 75,
          child: ListView(
            children: breed.subBreeds!.map((String item) {
              return Center(
                child: Text(item),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  SizedBox buildGenerateButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: MaterialButton(
        color: const Color(0xff0085FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onPressed: () => showRandomBreedImageDialog(context),
        child: Text(
          'Generate',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.white,
                fontSize: 16,
              ),
        ),
      ),
    );
  }

  void showRandomBreedImageDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: Builder(
            builder: (context) {
              final width = MediaQuery.of(context).size.width * 0.2;
              final height = MediaQuery.of(context).size.height * 0.4;
              return SizedBox(
                height: height,
                width: width,
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        child: FutureBuilder(
                          future: fetchImage(breed.breedName),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              return Image.network(
                                snapshot.data!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, obj, stack) {
                                  return const Center(
                                    child: Text(
                                      'Image Not Found!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        backgroundColor: Colors.black45,
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<String> fetchImage(String name) async {
    final result = await _breedRepo.getBreedImage(name);
    if (result != null) {
      return result.message;
    } else {
      return breed.breedImageUrl!;
    }
  }
}
