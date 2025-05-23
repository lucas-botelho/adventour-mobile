import 'package:adventour/models/base_api_response.dart';
import 'package:adventour/models/itinerary/itinerary.dart';
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
        endpoint: Itinerary.create,
        token: token,
        headers: <String, String>{},
        body: itinerary.toJson(),
        fromJsonT: (json) => ItineraryModel.fromJson(json),
      );

      return response;
    } catch (e) {
      print('Error saving itinerary: $e');
    }
  }
}
