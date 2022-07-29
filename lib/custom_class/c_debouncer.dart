import 'dart:async';
import 'package:flutter/material.dart';

class Debouncer {
  final int milliseconds;
  late VoidCallback action;
  late Timer _timer;

  Debouncer(this.milliseconds) {
    action = () { };
    _timer = Timer(const Duration(milliseconds: 0), action);
  }

  run(VoidCallback action) {
    // if (_timer != null) {
    //   _timer.cancel();
    // }

    _timer.cancel();

    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}