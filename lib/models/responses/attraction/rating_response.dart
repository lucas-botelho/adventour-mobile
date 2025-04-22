class RatingResponse {
  final int id;
  final int value;

  RatingResponse({required this.id, required this.value});

  factory RatingResponse.fromJson(Map<String, dynamic> json) {
    return RatingResponse(
      id: json['id'],
      value: json['value'],
    );
  }
}
