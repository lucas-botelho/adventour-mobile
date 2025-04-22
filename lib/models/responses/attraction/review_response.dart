import 'package:adventour/models/responses/attraction/rating_response.dart';
import 'package:adventour/models/responses/auth/user.dart';

class ReviewResponse {
  final int id;
  final int ratingId;
  final RatingResponse rating;
  final int attractionId;
  final String userId;
  final UserResponse person;
  final String comment;
  final String title;

  ReviewResponse({
    required this.id,
    required this.ratingId,
    required this.rating,
    required this.attractionId,
    required this.userId,
    required this.person,
    required this.comment,
    required this.title,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      id: json['id'],
      ratingId: json['ratingId'],
      rating: RatingResponse.fromJson(json['rating']),
      attractionId: json['attractionId'],
      userId: json['userId'],
      person: UserResponse.fromJson(json['person']),
      comment: json['comment'],
      title: json['title'],
    );
  }
}
