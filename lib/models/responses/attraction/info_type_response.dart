class AttractionInfoTypeResponse {
  final int id;
  final String typeTitle;

  AttractionInfoTypeResponse({
    required this.id,
    required this.typeTitle,
  });

  factory AttractionInfoTypeResponse.fromJson(Map<String, dynamic> json) {
    return AttractionInfoTypeResponse(
      id: json['id'] as int,
      typeTitle: json['typeTitle'] as String,
    );
  }
}
