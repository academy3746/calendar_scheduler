import 'dart:io';
import 'package:calendar_scheduler/common/constants/date.dart';
import 'package:calendar_scheduler/features/home/models/schedule_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

class ScheduleRepository {
  /// Open Database
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  final _dio = Dio();

  final _targetUrl =
      'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:3000/schedule';

  /// 일정 조회
  Future<List<ScheduleModel>> getSchedules({required DateTime date}) async {
    List<ScheduleModel> scheduleList = [];

    final serverTime = dateFormat.format(date);

    final snapshot = await _database
        .collection('schedule')
        .where(
          'date',
          isEqualTo: serverTime,
        )
        .get();

    scheduleList = snapshot.docs
        .map(
          (doc) => ScheduleModel.fromJson(
            doc.data(),
          ),
        )
        .toList();

    return scheduleList;
  }

  /// 일정 생성
  Future<void> createSchedule({required ScheduleModel model}) async {
    await _database.collection('schedule').doc(model.id).set(model.toMap());
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
