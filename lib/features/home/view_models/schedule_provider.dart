import 'package:calendar_scheduler/features/home/models/schedule_model.dart';
import 'package:calendar_scheduler/features/home/repositories/schedule_repo.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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

    const uuid = Uuid();

    final tempId = uuid.v4();

    final newModel = model.copyWith(
      id: tempId,
    );

    cache.update(
      date,
      (value) => [
        ...value,
        newModel,
      ]..sort(
          (a, b) => a.startTime.compareTo(
            b.startTime,
          ),
        ),
      ifAbsent: () => [newModel],
    );

    notifyListeners();

    try {
      final savedData = await repo.createSchedule(model: model);

      cache.update(
        date,
        (value) => value
            .map(
              (element) => element.id == tempId
                  ? element.copyWith(
                      id: savedData,
                    )
                  : element,
            )
            .toList(),
      );
    } catch (error) {
      cache.update(
        date,
        (value) => value
            .where(
              (element) => element.id != tempId,
            )
            .toList(),
      );
    }

    notifyListeners();
  }

  /// 일정 삭제 (UI State)
  Future<void> deleteSchedule({
    required DateTime date,
    required String id,
  }) async {
    final targetedSchedule = cache[date]!.firstWhere(
      (element) => element.id == id,
    );

    cache.update(
      date,
      (value) => value
          .where(
            (e) => e.id != id,
          )
          .toList(),
      ifAbsent: () => [],
    );

    notifyListeners();

    try {
      await repo.deleteSchedule(id: id);
    } catch (error) {
      cache.update(
        date,
        (value) => [
          ...value,
          targetedSchedule,
        ]..sort(
            (a, b) => a.startTime.compareTo(b.startTime),
          ),
      );
    }

    notifyListeners();
  }

  /// 날짜 변경 (UI State)
  void changeSelectedDate({required DateTime date}) {
    selectedDate = date;

    notifyListeners();
  }
}
