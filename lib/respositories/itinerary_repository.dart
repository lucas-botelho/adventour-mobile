import 'package:adventour/models/base_api_response.dart';
import 'package:adventour/models/itinerary/itinerary.dart';
import 'package:adventour/models/responses/itinerary/itinerarylist.dart';
import 'package:adventour/services/api_service.dart';
import 'package:adventour/services/firebase_auth_service.dart';
import 'package:adventour/settings/constants.dart';

class ItineraryRepository {
  final FirebaseAuthService authService;
  final ApiService apiService;

  ItineraryRepository({required this.authService, required this.apiService});

  Future<BaseApiResponse<ItineraryModel>?> saveItinerary(
    ItineraryModel itinerary,
  ) async {
    final token = await authService.getIdToken();
    try {
      final response = await apiService.post(
        endpoint: Itinerary.itinerary,
        token: token,
        headers: <String, String>{},
        body: itinerary.toJson(),
        fromJsonT: (json) => ItineraryModel.fromJson(json),
      );

      return response;
    } catch (e) {
      print('Error saving itinerary: $e');
    }

    return null;
  }

  Future<BaseApiResponse<ItineraryListResponse>?> getItineraries(String countryCode) async {
    final token = await authService.getIdToken();

    try {
      final response = await apiService.get(
        '${Itinerary.itinerary}?countryCode=$countryCode',
        token,
        headers: <String, String>{},
        fromJsonT: (json) => ItineraryListResponse.fromJson(json),
      );

      return response;
    } catch (e) {
      print('Error fetching itineraries: $e');
      return null;
    }
  }

  Future<BaseApiResponse<String>?> deleteItinerary(int itineraryId) async {
    final token = await authService.getIdToken();

    try {
      final response = await apiService.delete(
        endpoint: '${Itinerary.itinerary}/$itineraryId',
        token: token,
        headers: <String, String>{},
        fromJsonT: (json) => json.toString(),
      );

      return response;
    } catch (e) {
      print('Error deleting itinerary: $e');
      return null;
    }
  }

}
