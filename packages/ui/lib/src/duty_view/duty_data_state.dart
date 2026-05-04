import 'dart:async';

import 'package:flutter/material.dart';

class DutyDataState with ChangeNotifier {
  DutyDataState({
    required this.title,
    required int seconds,
    final int? initialValue,
    bool isRunning = false,
    this.showSeconds = true,
    this.isDecreasing = true,
  }) : initialSeconds = initialValue ?? seconds {
    _seconds = seconds;
    _isTimerRunning = isRunning;

    _timerFn();
  }

  final String title;
  final int initialSeconds;
  final bool showSeconds;
  final bool isDecreasing;

  bool _isTimerRunning = false;
  int _seconds = 0;
  Timer? _timer;

  bool _isDisposed = false;

  int get seconds => _seconds;
  set seconds(int seconds) {
    if (_seconds == seconds) return;
    _seconds = seconds;

    _timerFn();
  }

  bool get isTimerRunning => _isTimerRunning;
  set isTimerRunning(bool isTimerRunning) {
    if (_isTimerRunning == isTimerRunning) return;
    _isTimerRunning = isTimerRunning;

    _timerFn();
  }

  void _timerFn() {
    if (_isDisposed) {
      _timer?.cancel();
      _timer = null;
      return;
    }

    if (_isTimerRunning) {
      _timer?.cancel();
      _timer = null;

      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_isDisposed) {
          _timer?.cancel();
          _timer = null;
          return;
        }

        if (_seconds == 0) {
          _timer?.cancel();
          _timer = null;
          return;
        }

        _seconds += isDecreasing ? -1 : 1;
        notifyListeners();
      });
    } else {
      _timer?.cancel();
      _timer = null;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
