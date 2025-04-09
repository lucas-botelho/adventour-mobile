import 'package:adventour/models/responses/attraction/attraction_image_response.dart';

class BasicAttractionResponse {
  final int id;
  final bool isFavorited;
  final String name;
  final String description;
  final List<AttractionImageResponse> attractionImages;

  BasicAttractionResponse({
    required this.id,
    required this.isFavorited,
    required this.name,
    required this.description,
    required this.attractionImages,
  });

  factory BasicAttractionResponse.fromJson(Map<String, dynamic> json) {
    return BasicAttractionResponse(
      id: json['id'] as int,
      isFavorited: json['isFavorited'] as bool,
      name: json['name'] as String,
      description: json['description'] as String,
      attractionImages: (json['attractionImages'] as List<dynamic>)
          .map((item) =>
              AttractionImageResponse.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
