import 'dart:async';

import 'package:flutter/foundation.dart';

class ClockProvider with ChangeNotifier {
  DateTime _currentTime = DateTime.now();

  DateTime get currentTime => _currentTime;
  ClockProvider() {
    Timer.periodic(Duration(seconds: 59), (timer) {
      _updateTime();
    });
  }
  void _updateTime() {
    _currentTime = DateTime.now();
    notifyListeners();
  }
}
