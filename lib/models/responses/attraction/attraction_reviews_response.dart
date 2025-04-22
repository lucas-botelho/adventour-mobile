import 'package:adventour/models/responses/attraction/review_with_image_response.dart';

class AttractionReviewsResponse {
  final List<ReviewWithImagesResponse> reviews;

  AttractionReviewsResponse({required this.reviews});

  factory AttractionReviewsResponse.fromJson(Map<String, dynamic> json) {
    return AttractionReviewsResponse(
      reviews: (json['reviews'] as List<dynamic>)
          .map((e) => ReviewWithImagesResponse.fromJson(e))
          .toList(),
    );
  }

  double calculateAverageRating() {
    if (reviews.isEmpty) {
      return 0;
    }
    int sum = 0;
    for (var review in reviews) {
      sum += review.data.rating.value;
    }
    return sum / reviews.length;
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
