import 'package:calendar_scheduler/common/constants/date.dart';

class ScheduleModel {
  final String id;

  final String content;

  final DateTime date;

  final int startTime;

  final int endTime;

  ScheduleModel({
    required this.id,
    required this.content,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'date': dateFormat.format(date),
      'startTime': startTime,
      'endTime': endTime
    };
  }

  factory ScheduleModel.fromJson(Map<String, dynamic> data) {
    return ScheduleModel(
      id: data['id'],
      content: data['content'],
      date: DateTime.parse(data['date']),
      startTime: data['startTime'],
      endTime: data['endTime'],
    );
  }

  ScheduleModel copyWith({
    String? id,
    String? content,
    DateTime? date,
    int? startTime,
    int? endTime,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      content: content ?? this.content,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
