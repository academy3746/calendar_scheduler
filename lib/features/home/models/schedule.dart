import 'package:drift/drift.dart';

class Schedules extends Table {
  /// PK & Auto Increment
  IntColumn get id => integer().autoIncrement()();

  /// 내용
  TextColumn get content => text()();

  /// 날짜
  DateTimeColumn get date => dateTime()();

  /// 시작 시간
  IntColumn get startTime => integer()();

  /// 종료 시간
  IntColumn get endTime => integer()();
}
