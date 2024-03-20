import 'package:calendar_scheduler/features/home/models/schedule.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'drift_database.g.dart';

@DriftDatabase(
  tables: [
    Schedules,
  ],
)
class LocalDataBase extends _$LocalDataBase {
  LocalDataBase() : super(_openConnection());

  /// SELECT
  Stream<List<Schedule>> watchSchedules(DateTime date) {
    return (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();
  }

  /// INSERT
  Future<int> createSchedule(SchedulesCompanion data) {
    return into(schedules).insert(data);
  }

  /// DELETE
  Future<int> removeSchedule(int id) {
    return (delete(schedules)..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  int get schemaVersion => 1;
}

/// Open DB Connection on both AOS & IOS Platform
LazyDatabase _openConnection() {
  return LazyDatabase(
    () async {
      final dbFolder = await getApplicationDocumentsDirectory();

      final file = File(
        p.join(
          dbFolder.path,
          'db.sqlite',
        ),
      );

      return NativeDatabase(file);
    },
  );
}
