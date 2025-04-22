import 'package:adventour/models/responses/attraction/attraction_image_response.dart';
import 'package:adventour/models/responses/attraction/review_response.dart';

class ReviewWithImagesResponse {
  final ReviewResponse data;
  final List<AttractionImageResponse> images;

  ReviewWithImagesResponse({
    required this.data,
    required this.images,
  });

  factory ReviewWithImagesResponse.fromJson(Map<String, dynamic> json) {
    return ReviewWithImagesResponse(
      data: ReviewResponse.fromJson(json['review']),
      images: (json['images'] as List<dynamic>)
          .map((img) => AttractionImageResponse.fromJson(img))
          .toList(),
    );
  }
}
