import 'dart:convert';

BreedListResponse breedListResponseFromJson(String str) =>
    BreedListResponse.fromJson(json.decode(str) as Map<String, dynamic>);

class BreedListResponse {
  BreedListResponse({
    required this.message,
    required this.status,
  });

  factory BreedListResponse.fromJson(dynamic json) {
    return BreedListResponse(
      message: json['message'] as Map<String, dynamic>,
      status: json['status'] as String,
    );
  }

  List<String> getBreedList() {
    return message.keys.toList();
  }

  Map<String, dynamic> message;
  String status;
}
