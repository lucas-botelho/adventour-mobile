import 'package:adventour/models/responses/attraction/basic_attraction_response.dart';

class TimeSlot {
  final int? id;
  final String? name;
  final DateTime startTime;
  final DateTime endTime;
  final int? attractionId;
  final BasicAttractionResponse? attraction;

  TimeSlot({
    this.id,
    this.name,
    required this.startTime,
    required this.endTime,
    this.attractionId,
    this.attraction,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
      return TimeSlot(
      id: json['id'],
      name: json['name'],
      startTime: DateTime.parse(json['start_time'] ?? json['startTime']),
      endTime: DateTime.parse(json['end_time'] ?? json['endTime']),
      attractionId: json['attraction_id'],
      attraction: json['attraction'] != null
          ? BasicAttractionResponse.fromJson(json['attraction'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name ?? '',
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'attraction_id': attraction?.id ?? '',
    };
  }

}
