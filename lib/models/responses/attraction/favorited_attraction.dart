class FavoritedAttractionDetails {
  final int id;
  final String name;
  final double averageRating;
  final String countryName;
  final String imageUrl;

  FavoritedAttractionDetails({
    required this.imageUrl,
    required this.id,
    required this.name,
    required this.averageRating,
    required this.countryName,
  });

  factory FavoritedAttractionDetails.fromJson(Map<String, dynamic> json) {
    return FavoritedAttractionDetails(
      id: json['id'] as int,
      name: json['name'] as String,
      averageRating: (json['averageRating'] as num).toDouble(),
      countryName: json['countryName'] as String,
      imageUrl: json['image'] as String,
    );
  }
}