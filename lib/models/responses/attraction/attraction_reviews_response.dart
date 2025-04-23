import 'package:adventour/models/responses/attraction/review_with_image_response.dart';

class AttractionReviewsResponse {
  final List<ReviewWithImagesResponse> reviews;
  final double averageRating;

  AttractionReviewsResponse({required this.reviews, required this.averageRating});

  factory AttractionReviewsResponse.fromJson(Map<String, dynamic> json) {
    return AttractionReviewsResponse(
      reviews: (json['reviews'] as List<dynamic>)
          .map((e) => ReviewWithImagesResponse.fromJson(e))
          .toList(),
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  int fiveStarCount() {
    return reviews.where((review) => review.data.rating.value == 5).length;
  }
  int fourStarCount() {
    return reviews.where((review) => review.data.rating.value == 4).length;
  }
  int threeStarCount() {
    return reviews.where((review) => review.data.rating.value == 3).length;
  }
  int twoStarCount() {
    return reviews.where((review) => review.data.rating.value == 2).length;
  }
  int oneStarCount() {
    return reviews.where((review) => review.data.rating.value == 1).length;
  }
}
