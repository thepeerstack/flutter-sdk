import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  VoidCallback? action;
  final int? milliseconds;
  Timer? _timer;

  Debouncer({this.milliseconds});

  void run<T>(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds!), action);
  }
}
