import 'package:breedy/domain/models/breed.dart';
import 'package:breedy/domain/repository/breed_repository.dart';
import 'package:flutter/material.dart';

class BreedRandomImageDialog extends StatelessWidget {
  BreedRandomImageDialog({required this.breed, super.key});
  final Breed breed;
  final _breedRepository = BreedRepository();

  @override
  Widget build(BuildContext context) {
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
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: FutureBuilder(
                      future: fetchImage(breed.breedName),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.connectionState == ConnectionState.done &&
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
  }

  Future<String> fetchImage(String name) async {
    final result = await _breedRepository.getBreedImage(name);
    if (result != null) {
      return result.message;
    } else {
      return breed.breedImageUrl!;
    }
  }
}
