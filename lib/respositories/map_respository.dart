import 'package:adventour/models/base_api_response.dart';
import 'package:adventour/models/responses/country/countries_list.dart';
import 'package:adventour/models/responses/country/country.dart';
import 'package:adventour/services/api_service.dart';
import 'package:adventour/services/firebase_auth_service.dart';
import 'package:adventour/settings/constants.dart';

class MapRepository {
  final ApiService apiService;
  final FirebaseAuthService authService;

  MapRepository({required this.apiService, required this.authService});

  Future<BaseApiResponse<CountryResponse>?> getCountryData(
      String countryIsoCode) async {
    final result = await apiService.get(
      '${Country.getCountry}/$countryIsoCode',
      await authService.getIdToken(),
      headers: <String, String>{},
      fromJsonT: (json) => CountryResponse.fromJson(json),
    );

    return result;
  }

  Future<BaseApiResponse<CountryResponse>?> getCountry(String isoCode) async {
    final result = await apiService.get(
      '${Country.getCountry}/$isoCode',
      await authService.getIdToken(),
      headers: <String, String>{},
      fromJsonT: (json) => CountryResponse.fromJson(json),
    );

    return result;
  }

  Future<BaseApiResponse<CountryListResponse>?> getCountries(
      String continentName, int page, String countryCode) async {
    final result = await apiService.get(
      '${Country.listCountries}?continent=$continentName&page=$page&pageSize=5&selectedCountryCode=$countryCode',
      await authService.getIdToken(),
      headers: <String, String>{},
      fromJsonT: (json) => CountryListResponse.fromJson(json),
    );

    return result;
  }
}
