// ignore_for_file: avoid_print

import 'package:calendar_scheduler/common/constants/gaps.dart';
import 'package:calendar_scheduler/common/constants/sizes.dart';
import 'package:calendar_scheduler/common/utils/app_snackbar.dart';
import 'package:calendar_scheduler/common/utils/common_text_field.dart';
import 'package:calendar_scheduler/data/drift_database.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ScheduleBottomSheet extends StatefulWidget {
  const ScheduleBottomSheet({
    super.key,
    required this.selectedTime,
  });

  final DateTime selectedTime;

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  /// Form Field Validate Key
  final GlobalKey<FormState> _formKey = GlobalKey();

  /// 시작 시간
  int? startTime;

  /// 종료 시간
  int? endTime;

  /// 내용
  String? content;

  /// 작성 내용 저장
  Future<void> _onSavePressed() async {
    var snackbar = AppSnackbar(
      context: context,
      msg: '작성 내용이 저장 되었습니다!',
    );

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await GetIt.I<LocalDataBase>().createSchedule(
        SchedulesCompanion(
          startTime: Value(startTime!),
          endTime: Value(endTime!),
          content: Value(content!),
          date: Value(widget.selectedTime),
        ),
      );

      if (!mounted) return;

      snackbar.showSnackbar(context);

      Navigator.of(context).pop();
    }
  }

  /// 시간 값 검증
  String? _timeValidator(String? value) {
    if (value == null) {
      return '값을 입력해 주세요!';
    }

    int? number;

    try {
      number = int.parse(value);
    } catch (error) {
      return '숫자를 입력해 주세요!';
    }

    if (number < 0 || number > 24) {
      return '0과 24 사이의 숫자를 입력해 주세요!';
    }

    return null;
  }

  /// 내용 값 검증
  String? _contentValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '내용을 입력해 주세요!';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInsect = MediaQuery.of(context).viewInsets.bottom;

    return Form(
      key: _formKey,
      child: SafeArea(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height / 2 + bottomInsect,
          child: Padding(
            padding: EdgeInsets.only(
              left: Sizes.size10,
              right: Sizes.size10,
              top: Sizes.size10,
              bottom: bottomInsect,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    /// 일정 시작
                    Expanded(
                      child: CommonTextField(
                        label: '시작 시간',
                        timeSelected: true,
                        onSaved: (String? value) {
                          startTime = int.parse(value!);
                        },
                        validator: _timeValidator,
                      ),
                    ),
                    Gaps.h16,

                    /// 일정 종료
                    Expanded(
                      child: CommonTextField(
                        label: '종료 시간',
                        timeSelected: true,
                        onSaved: (String? value) {
                          endTime = int.parse(value!);
                        },
                        validator: _timeValidator,
                      ),
                    ),
                  ],
                ),
                Gaps.v10,

                /// 일정 내용
                Expanded(
                  child: CommonTextField(
                    label: '내용',
                    timeSelected: false,
                    onSaved: (String? value) {
                      content = value;
                    },
                    validator: _contentValidator,
                  ),
                ),

                /// 작성 완료 Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onSavePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text(
                      '작성 완료',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
