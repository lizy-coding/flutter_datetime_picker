import 'package:flutter/material.dart';

class TimePickerProvider extends ChangeNotifier {
  double _hour = 0;
  double _minute = 0;
  final FixedExtentScrollController _hourController = FixedExtentScrollController();
  final FixedExtentScrollController _minuteController = FixedExtentScrollController();

  double get hour => _hour;
  double get minute => _minute;
  FixedExtentScrollController get hourController => _hourController;
  FixedExtentScrollController get minuteController => _minuteController;

  void initialize(TimeOfDay initialTime) {
    _hour = initialTime.hour.toDouble();
    _minute = initialTime.minute.toDouble();
    _hourController.jumpToItem(_hour.toInt());
    _minuteController.jumpToItem(_minute.toInt());
    notifyListeners();
  }

  void updateHour(int index) {
    _hour = index.toDouble();
    notifyListeners();
  }

  void updateMinute(int index) {
    _minute = index.toDouble();
    notifyListeners();
  }

  void _updateHourWithController(double newHour) {
    _hour = newHour;
    _hourController.jumpToItem(_hour.toInt());
    notifyListeners();
  }

  void _updateMinuteWithController(double newMinute) {
    _minute = newMinute;
    _minuteController.jumpToItem(_minute.toInt());
    notifyListeners();
  }

  void incrementHour() {
    _updateHourWithController((_hour + 1) % 24);
  }

  void decrementHour() {
    _updateHourWithController((_hour - 1 + 24) % 24);
  }

  void incrementMinute() {
    _updateMinuteWithController((_minute + 1) % 60);
  }

  void decrementMinute() {
    _updateMinuteWithController((_minute - 1 + 60) % 60);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }
} 