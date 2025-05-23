import 'package:adventour/models/itinerary/day.dart';

class ItineraryModel {
  final int? id;
  final String? name;
  final List<Day>? days;
  final String? userId;

  ItineraryModel({
    this.id,
    this.name,
    this.days,
    this.userId,
  });

  factory ItineraryModel.fromJson(Map<String, dynamic> json) {
    return ItineraryModel(
      id: json['id'],
      userId: json['userId'],
      name: json['title'],
      days: (json['days'] as List<dynamic>?)
          ?.map((day) => Day.fromJson(day))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'days': days?.map((day) => day.toJson()).toList(),
    };
  }
}
