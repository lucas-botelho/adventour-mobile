import 'package:adventour/models/itinerary/itinerary.dart';

class ItineraryListResponse {
  final List<ItineraryModel> itineraries;

  ItineraryListResponse({required this.itineraries});

  factory ItineraryListResponse.fromJson(Map<String, dynamic> json) {
    try {
      final rawList = json['itineraries'] as List<dynamic>;
      final itineraries = rawList
          .map((item) => ItineraryModel.fromJson(item as Map<String, dynamic>))
          .toList();

      return ItineraryListResponse(itineraries: itineraries);
    } catch (e) {
      print('Error parsing ItineraryListResponse: $e');
      return ItineraryListResponse(itineraries: []);
    }
  }
}
