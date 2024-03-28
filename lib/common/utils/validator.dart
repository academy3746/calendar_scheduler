import 'package:flutter/material.dart';

class FormValidator {
  final BuildContext context;

  FormValidator({required this.context});

  /// 시간 값 검증
  String? timeValidator(String? value) {
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
  String? contentValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '내용을 입력해 주세요!';
    }

    return null;
  }
}