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
      'date': '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}',
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
}
