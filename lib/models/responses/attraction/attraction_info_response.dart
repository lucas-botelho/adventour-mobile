import 'package:adventour/models/responses/attraction/info_type_response.dart';

class AttractionInfoResponse {
  final int id;
  final int attractionId;
  final int attractionInfoTypeId;
  final String title;
  final String description;
  final AttractionInfoTypeResponse? attractionInfoType;

  AttractionInfoResponse({
    required this.id,
    required this.attractionId,
    required this.attractionInfoTypeId,
    required this.title,
    required this.description,
    this.attractionInfoType,
  });

  factory AttractionInfoResponse.fromJson(Map<String, dynamic> json) {
    return AttractionInfoResponse(
      id: json['id'] as int,
      attractionId: json['attractionId'] as int,
      attractionInfoTypeId: json['attractionInfoTypeId'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      attractionInfoType: json['attractionInfoType'] != null
          ? AttractionInfoTypeResponse.fromJson(
          json['attractionInfoType'] as Map<String, dynamic>)
          : null,
    );
  }
}
