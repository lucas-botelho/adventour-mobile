import 'package:adventour/models/responses/attraction/attraction_image_response.dart';

class BasicAttractionResponse {
  final int id;
  final bool isFavorited;
  final String name;
  final String shortDescription;
  final String? longDescription;
  final double? distanceMeters;
  final List<AttractionImageResponse> attractionImages;
  final String country;
  final String address;
  final double? rating;

  BasicAttractionResponse({
    required this.id,
    required this.isFavorited,
    required this.name,
    required this.shortDescription,
    required this.longDescription,
    required this.distanceMeters,
    required this.attractionImages,
    required this.country,
    required this.address,
    required this.rating,
  });

  factory BasicAttractionResponse.fromJson(Map<String, dynamic> json) {
    return BasicAttractionResponse(
      id: json['id'] as int,
      isFavorited: json['isFavorited'] as bool,
      name: json['name'] as String,
      shortDescription: json['shortDescription'] as String,
      longDescription: json['longDescription'] as String?,
      distanceMeters: (json['distanceMeters'] as num?)?.toDouble(),
      attractionImages: (json['attractionImages'] as List<dynamic>)
          .map((item) =>
          AttractionImageResponse.fromJson(item as Map<String, dynamic>))
          .toList(),
      country: json['country'] as String,
      address: json['address'] as String,
      rating: (json['rating'] as num?)?.toDouble(),
    );
  }
}
