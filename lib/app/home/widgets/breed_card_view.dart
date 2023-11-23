import 'package:breedy/app/constants/theme_constants.dart';
import 'package:breedy/app/home/widgets/breed_detail_dialog.dart';
import 'package:breedy/domain/extension/string_extension.dart';
import 'package:breedy/domain/models/breed.dart';
import 'package:flutter/material.dart';

class BreedDetailView extends StatelessWidget {
  const BreedDetailView({required this.breed, super.key});
  final Breed breed;
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
      padding: kDefaultPadding,
      decoration: const BoxDecoration(
        color: Colors.black26,
        borderRadius: kBreedTitleBorderRadius,
      ),
      child: Center(
        child: Text(
          breed.breedName.capitalize(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  ClipRRect buildBreedClip() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        breed.breedImageUrl ?? '',
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
        return BreedDetailDialog(breed: breed);
      },
    );
  }
}
