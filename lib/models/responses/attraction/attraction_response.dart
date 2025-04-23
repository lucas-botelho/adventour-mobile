import 'package:adventour/models/responses/attraction/attraction_image_response.dart';

class AttractionResponse {
  final int id;
  final String name;
  final String? shortDescription;
  final List<AttractionImageResponse> attractionImages;
  final int countryId;
  final double? averageRating;
  final String? addressOne;
  final String? addressTwo;
  final String? longDescription;

  AttractionResponse({
    required this.id,
    required this.name,
    this.shortDescription,
    required this.attractionImages,
    required this.countryId,
    this.averageRating,
    this.addressOne,
    this.addressTwo,
    required this.longDescription,
  });

  factory AttractionResponse.fromJson(Map<String, dynamic> json) {
    return AttractionResponse(
      id: json['id'] as int,
      name: json['name'] as String,
      shortDescription: json['shortDescription'] as String?,
      attractionImages: (json['attractionImages'] as List<dynamic>)
          .map((item) =>
              AttractionImageResponse.fromJson(item as Map<String, dynamic>))
          .toList(),
      countryId: json['countryId'] as int,
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      addressOne: json['addressOne'] as String?,
      addressTwo: json['addressTwo'] as String?,
      longDescription: json['longDescription'] as String?,
    );
  }
}
