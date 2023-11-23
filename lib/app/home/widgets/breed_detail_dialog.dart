import 'package:breedy/app/constants/theme_constants.dart';
import 'package:breedy/app/home/widgets/breed_random_image_dialog.dart';
import 'package:breedy/domain/models/breed.dart';
import 'package:breedy/l10n/l10n.dart';
import 'package:flutter/material.dart';

class BreedDetailDialog extends StatelessWidget {
  const BreedDetailDialog({required this.breed, super.key});
  final Breed breed;

  @override
  Widget build(BuildContext context) {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: width,
                          width: width,
                          child: buildImageDetail(),
                        ),
                        buildCloseButton(context),
                      ],
                    ),
                    buildBreedNameDetail(context),
                    buildSubBreedDetail(context),
                  ],
                ),
                buildGenerateButton(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Positioned buildCloseButton(BuildContext context) {
    return Positioned(
      top: kDetailCloseButtonPosition,
      right: kDetailCloseButtonPosition,
      child: CircleAvatar(
        radius: kDetailCloseButtonRadius,
        backgroundColor: Colors.white,
        child: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  ClipRRect buildImageDetail() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
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

  Padding buildBreedNameDetail(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            context.l10n.breed,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: kPrimaryColor),
          ),
          const Divider(color: kDividerColor),
          Text(breed.breedName),
        ],
      ),
    );
  }

  Padding buildSubBreedDetail(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            context.l10n.subBreed,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: kPrimaryColor),
          ),
          const Divider(color: kDividerColor),
          SizedBox(
            height: 60,
            child: Builder(
              builder: (context) {
                if (breed.subBreeds!.isEmpty) {
                  return Text(context.l10n.none);
                } else {
                  return ListView(
                    children: breed.subBreeds!.map((String item) {
                      return Center(
                        child: Text(item),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Padding buildGenerateButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: MaterialButton(
          color: kGenerateButtonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          onPressed: () => showRandomBreedImageDialog(context),
          child: Text(
            context.l10n.generate,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  void showRandomBreedImageDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) {
        return BreedRandomImageDialog(breed: breed);
      },
    );
  }
}
