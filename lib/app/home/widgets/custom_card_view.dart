import 'package:breedy/domain/models/breed.dart';
import 'package:flutter/material.dart';

class CustomCardView extends StatelessWidget {
  const CustomCardView({required this.breed, super.key});
  final Breed breed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
}
