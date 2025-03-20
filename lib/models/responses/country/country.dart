class CountryResponse {
  final String name;
  final String continent;
  final int id;
  final String svg;

  CountryResponse({
    required this.name,
    required this.continent,
    required this.id,
    required this.svg,
  });

  factory CountryResponse.fromJson(Map<String, dynamic> json) {
    return CountryResponse(
      name: json['name'],
      continent: json['continentName'],
      id: json['id'],
      svg: json['svg'],
    );
  }
}
