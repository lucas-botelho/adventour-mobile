class CountryResponse {
  final String name;
  final String continent;
  final int id;

  CountryResponse(
      {required this.name, required this.continent, required this.id});

  factory CountryResponse.fromJson(Map<String, dynamic> json) {
    return CountryResponse(
      name: json['name'],
      continent: json['continentName'],
      id: json['id'],
    );
  }
}
