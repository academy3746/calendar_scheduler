import 'dart:io';
import 'package:calendar_scheduler/features/home/models/schedule_model.dart';
import 'package:dio/dio.dart';

class ScheduleRepository {
  final _dio = Dio();

  final _targetUrl =
      'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:3000/schedule';

  /// 일정 조회
  Future<List<ScheduleModel>> getSchedules({required DateTime date}) async {
    List<ScheduleModel> scheduleList = [];

    final res = await _dio.get(
      _targetUrl,
      queryParameters: {
        'date':
            '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}',
      },
    );

    scheduleList = res.data
        .map<ScheduleModel>(
          (e) => ScheduleModel.fromJson(e),
        )
        .toList();

    return scheduleList;
  }

  /// 일정 생성
  Future<String> createSchedule({required ScheduleModel model}) async {
    var schedule = '';

    final value = model.toMap();

    final res = await _dio.post(
      _targetUrl,
      data: value,
    );

    schedule = res.data?['id'];

    return schedule;
  }

  /// 일정 삭제
  Future<String> deleteSchedule({required String id}) async {
    var schedule = '';

    final res = await _dio.delete(
      _targetUrl,
      data: {
        'id': id,
      },
    );

    schedule = res.data?['id'];

    return schedule;
  }
}
