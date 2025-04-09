class ToggleFavoriteRequest {
  final int attractionId;
  final String userId;

  ToggleFavoriteRequest({required this.attractionId, required this.userId});

  Map<String, dynamic> toJson() {
    return {
      'attractionId': attractionId,
      'userId': userId,
    };
  }
}
