class AddToFavoriteRequest {
  final int attractionId;
  final String userId;

  AddToFavoriteRequest({required this.attractionId, required this.userId});

  Map<String, dynamic> toJson() {
    return {
      'attractionId': attractionId,
      'userId': userId,
    };
  }
}
