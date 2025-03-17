import 'package:flutter/material.dart';

class TimePickerProvider extends ChangeNotifier {
  double _hour = 0;
  double _minute = 0;
  final TextEditingController timeController = TextEditingController();

  double get hour => _hour;
  double get minute => _minute;

  void initialize(TimeOfDay initialTime) {
    _hour = initialTime.hour.toDouble();
    _minute = initialTime.minute.toDouble();
    _updateTimeController();
    notifyListeners();
  }

  void updateHour(int hour) {
    _hour = hour.toDouble();
    _updateTimeController();
    notifyListeners();
  }

  void updateMinute(int minute) {
    _minute = minute.toDouble();
    _updateTimeController();
    notifyListeners();
  }

  void incrementHour() {
    _hour = (_hour + 1) % 24;
    _updateTimeController();
    notifyListeners();
  }

  void decrementHour() {
    _hour = (_hour - 1 + 24) % 24;
    _updateTimeController();
    notifyListeners();
  }

  void incrementMinute() {
    _minute = (_minute + 1) % 60;
    _updateTimeController();
    notifyListeners();
  }

  void decrementMinute() {
    _minute = (_minute - 1 + 60) % 60;
    _updateTimeController();
    notifyListeners();
  }

  void _updateTimeController() {
    timeController.text =
        '${_hour.toInt().toString().padLeft(2, '0')}:${_minute.toInt().toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    timeController.dispose();
    super.dispose();
  }
} 