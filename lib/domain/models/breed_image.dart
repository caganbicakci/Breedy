import 'dart:convert';

BreedImage breedImageFromJson(String str) =>
    BreedImage.fromJson(json.decode(str) as Map<String, dynamic>);

class BreedImage {
  BreedImage({
    required this.message,
    required this.status,
  });

  factory BreedImage.fromJson(dynamic json) {
    return BreedImage(
      message: json['message'] as String,
      status: json['status'] as String,
    );
  }

  String message;
  String status;
}
