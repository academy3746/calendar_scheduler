import 'package:calendar_scheduler/common/constants/sizes.dart';
import 'package:flutter/material.dart';

class TodayBanner extends StatelessWidget {
  const TodayBanner({
    super.key,
    required this.selectedDate,
    required this.count,
  });

  final DateTime selectedDate;

  final int count;

  @override
  Widget build(BuildContext context) {
    const widgetTextStyle =
        TextStyle(color: Colors.white, fontWeight: FontWeight.w600);

    return Container(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size16,
          vertical: Sizes.size10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일',
              style: widgetTextStyle,
            ),
            Text(
              '$count개',
              style: widgetTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
