import 'package:flutter/material.dart';

extension CustomContext on BuildContext {
  double screenHeight([double percent = 1]) =>
      MediaQuery.of(this).size.height * percent;

  double screenWidth([double percent = 1]) =>
      MediaQuery.of(this).size.width * percent;
}

extension Slice on String {
  String slice([int start = 0, int? end]) {
    int _realEnd;
    final _realStart = start < 0 ? length + start : start;
    if (end is! int) {
      _realEnd = length;
    } else {
      _realEnd = end < 0 ? length + end : end;
    }

    return substring(_realStart, _realEnd);
  }
}
