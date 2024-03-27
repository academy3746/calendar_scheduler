import 'package:calendar_scheduler/common/constants/gaps.dart';
import 'package:calendar_scheduler/common/constants/sizes.dart';
import 'package:calendar_scheduler/features/home/view_models/schedule_provider.dart';
import 'package:calendar_scheduler/features/home/widgets/main_calendar.dart';
import 'package:calendar_scheduler/features/home/widgets/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/features/home/widgets/schedule_card.dart';
import 'package:calendar_scheduler/features/home/widgets/today_banner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    /// Provider 객체 생성
    final provider = context.watch<ScheduleProvider>();

    /// 선택된 날짜 객체 생성
    final thisSelectedDate = provider.selectedDate;

    /// 선택된 날짜에 해당되는 일정 호출
    final schedules = provider.cache[thisSelectedDate] ?? [];

    /// 선택된 날짜 Handling
    void onDaySelected(
      DateTime selectedDate,
      DateTime focusedDate,
      BuildContext context,
    ) {
      final provider = context.read<ScheduleProvider>();

      provider.changeSelectedDate(date: selectedDate);

      provider.getSchedules(date: selectedDate);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: const EdgeInsets.all(Sizes.size20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 달력
            MainCalendar(
              onDaySelected: (selectedDate, focusedDate) => onDaySelected(
                selectedDate,
                focusedDate,
                context,
              ),
              selectedDate: thisSelectedDate,
            ),
            Gaps.v10,

            /// 오늘 일정 개수
            TodayBanner(
              selectedDate: thisSelectedDate,
              count: schedules.length,
            ),

            /// 오늘 일정
            Expanded(
              child: ListView.builder(
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  final db = schedules[index];

                  return Dismissible(
                    key: ObjectKey(db.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      provider.deleteSchedule(
                        date: thisSelectedDate,
                        id: db.id,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: Sizes.size10,
                        left: Sizes.size8,
                        right: Sizes.size8,
                      ),
                      child: ScheduleCard(
                        startTime: db.startTime,
                        endTime: db.endTime,
                        content: db.content,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ScheduleBottomSheet(
                  selectedTime: thisSelectedDate,
                ),
              );
            },
            isScrollControlled: true,
            isDismissible: true,
          );
        },
        child: const Icon(
          color: Colors.white,
          Icons.add,
          size: Sizes.size32,
        ),
      ),
    );
  }
}
