import 'package:adventour/models/itinerary/timeslot.dart';

class Day {
  final int? id;
  final int? dayNumber;
  List<TimeSlot>? timeslots;

  Day({
    this.id,
    this.dayNumber,
    this.timeslots,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      id: json['id'],
      dayNumber: json['dayNumber'],
      timeslots: (json['timeslots'] as List<dynamic>?)
          ?.map((slot) => TimeSlot.fromJson(slot))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayNumber': dayNumber,
      'timeslots': timeslots?.map((slot) => slot.toJson()).toList(),
    };
  }
}
