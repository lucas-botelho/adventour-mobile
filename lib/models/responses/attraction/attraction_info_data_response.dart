import 'package:adventour/models/responses/attraction/attraction_info_response.dart';
import 'package:adventour/models/responses/attraction/info_type_response.dart';

class AttractionInfoDataResponse {
  final List<AttractionInfoTypeResponse> infoTypes;
  final List<AttractionInfoResponse> attractionInfos;

  AttractionInfoDataResponse({
    required this.infoTypes,
    required this.attractionInfos,
  });

  factory AttractionInfoDataResponse.fromJson(Map<String, dynamic> json) {
    return AttractionInfoDataResponse(
      infoTypes: (json['infoTypes'] as List<dynamic>)
          .map((e) =>
          AttractionInfoTypeResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      attractionInfos: (json['attractionInfos'] as List<dynamic>)
          .map((e) =>
          AttractionInfoResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
