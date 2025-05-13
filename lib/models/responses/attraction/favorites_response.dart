import 'package:adventour/models/responses/attraction/favorited_attraction.dart';

class FavoritesResponse {
  final List<FavoritedAttractionDetails> attractions;

  FavoritesResponse({
    required this.attractions,
  });

  factory FavoritesResponse.fromJson(Map<String, dynamic> json) {
    return FavoritesResponse(
      attractions: (json['attractions'] as List<dynamic>)
          .map((item) => FavoritedAttractionDetails.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}