// ignore_for_file: deprecated_member_use

import 'package:calendar_scheduler/common/constants/gaps.dart';
import 'package:calendar_scheduler/common/constants/sizes.dart';
import 'package:calendar_scheduler/common/utils/back_handler_button.dart';
import 'package:calendar_scheduler/data/drift_database.dart';
import 'package:calendar_scheduler/features/home/widgets/main_calendar.dart';
import 'package:calendar_scheduler/features/home/widgets/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/features/home/widgets/schedule_card.dart';
import 'package:calendar_scheduler/features/home/widgets/today_banner.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// 뒤로가기 Action
  BackHandlerButton? backHandlerButton;

  /// 선택된 날짜 객체 생성
  DateTime thisSelectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  void initState() {
    super.initState();

    backHandlerButton = BackHandlerButton(context: context);
  }

  /// 선택된 날짜 Handling
  void _onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      thisSelectedDate = selectedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (backHandlerButton != null) {
          return backHandlerButton!.onWillPop();
        }

        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: const EdgeInsets.all(Sizes.size20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 달력
              MainCalendar(
                onDaySelected: _onDaySelected,
                selectedDate: thisSelectedDate,
              ),
              Gaps.v10,

              /// 오늘 일자
              TodayBanner(
                selectedDate: thisSelectedDate,
                count: 0,
              ),

              /// 오늘 일정
              Expanded(
                child: StreamBuilder<List<Schedule>>(
                  stream:
                      GetIt.I<LocalDataBase>().watchSchedules(thisSelectedDate),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text(
                          '등록된 일정이 없습니다.',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: Sizes.size14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final db = snapshot.data![index];

                        return Dismissible(
                          key: ObjectKey(db.id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            GetIt.I<LocalDataBase>().removeSchedule(db.id);
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
      ),
    );
  }
}
