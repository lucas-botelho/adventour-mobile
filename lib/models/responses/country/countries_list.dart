import 'package:adventour/models/responses/country/country.dart';

class CountryListResponse {
  final List<CountryResponse> countries; // Use CountryResponse for the list
  final int totalCountries;
  CountryListResponse({
    required this.countries,
    required this.totalCountries,
  });

  factory CountryListResponse.fromJson(Map<String, dynamic> json) {
    return CountryListResponse(
      countries: (json['countries']
              as List<dynamic>) // Parse the 'countries' field
          .map((item) => CountryResponse.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalCountries: json['total'] as int,
    );
  }
}
