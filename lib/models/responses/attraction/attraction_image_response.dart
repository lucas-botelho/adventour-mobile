class AttractionImageResponse {
  final int id;
  final bool isMain;
  final String url;

  AttractionImageResponse({
    required this.id,
    required this.isMain,
    required this.url,
  });

  factory AttractionImageResponse.fromJson(Map<String, dynamic> json) {
    return AttractionImageResponse(
      id: json['id'] as int,
      isMain: json['isMain'] as bool,
      url: json['pictureRef'] as String,
    );
  }
}
