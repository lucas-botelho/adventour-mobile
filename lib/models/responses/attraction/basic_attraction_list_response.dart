import 'package:adventour/models/responses/attraction/basic_attraction_response.dart';

class BasicAttractionListResponse {
  final List<BasicAttractionResponse> attractions;

  BasicAttractionListResponse({
    required this.attractions,
  });

  factory BasicAttractionListResponse.fromJson(Map<String, dynamic> json) {
    return BasicAttractionListResponse(
      attractions: (json['attractions'] as List<dynamic>)
          .map((item) =>
              BasicAttractionResponse.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
