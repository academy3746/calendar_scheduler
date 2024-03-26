import 'package:calendar_scheduler/features/home/models/schedule_model.dart';
import 'package:calendar_scheduler/features/home/repositories/schedule_repo.dart';
import 'package:flutter/material.dart';

class ScheduleProvider extends ChangeNotifier {
  final ScheduleRepository repo;

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  Map<DateTime, List<ScheduleModel>> cache = {};

  ScheduleProvider({required this.repo}) {
    repo.getSchedules(date: selectedDate);
  }

  /// 일정 조회 (UI State)
  Future<void> getSchedules({required DateTime date}) async {
    final res = await repo.getSchedules(date: date);

    cache.update(
      date,
      (value) => res,
      ifAbsent: () => res,
    );

    notifyListeners();
  }

  /// 일정 생성 (UI State)
  Future<void> createSchedule({required ScheduleModel model}) async {
    final date = model.date;

    final data = await repo.createSchedule(model: model);

    cache.update(
      date,
      (value) => [
        ...value,
        model.copyWith(
          id: data,
        ),
      ]..sort(
          (a, b) => a.startTime.compareTo(
            b.startTime,
          ),
        ),
      ifAbsent: () => [model],
    );

    notifyListeners();
  }

  /// 일정 삭제 (UI State)
  Future<void> deleteSchedule({
    required DateTime date,
    required String id,
  }) async {
    await repo.deleteSchedule(id: id);

    cache.update(
      date,
      (value) => value.where((e) => e.id != id).toList(),
      ifAbsent: () => [],
    );

    notifyListeners();
  }

  /// 날짜 변경 (UI State)
  void changeSelectedDate({required DateTime date}) {
    selectedDate = date;

    notifyListeners();
  }
}
