import 'package:flutter/material.dart';
import '../models/date_time_picker_type.dart';

class DateTimePickerProvider extends ChangeNotifier {
  DateTime? _selectedDate;
  double _hour = 0;
  double _minute = 0;
  final TextEditingController timeController = TextEditingController();
  final DateTimePickerType _type;

  DateTime? get selectedDate => _selectedDate;
  double get hour => _hour;
  double get minute => _minute;
  DateTimePickerType get type => _type;

  DateTimePickerProvider({required DateTimePickerType type}) : _type = type;

  void initialize(DateTime initialDate, TimeOfDay initialTime) {
    _selectedDate = initialDate;
    _hour = initialTime.hour.toDouble();
    _minute = initialTime.minute.toDouble();
    _updateTimeController();
    notifyListeners();
  }

  void updateDate(DateTime date) {
    if (_selectedDate != date) {
      _selectedDate = date;
      notifyListeners();
    }
  }

  void updateTime(TimeOfDay time) {
    _hour = time.hour.toDouble();
    _minute = time.minute.toDouble();
    _updateTimeController();
    notifyListeners();
  }

  DateTime? getNormalizedDateTime() {
    if (_selectedDate == null) return null;

    switch (_type) {
      case DateTimePickerType.date:
        return DateTime.utc(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
        );
      case DateTimePickerType.time:
        return DateTime.utc(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          _hour.toInt(),
          _minute.toInt(),
        );
      case DateTimePickerType.datetime:
        return DateTime.utc(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _hour.toInt(),
          _minute.toInt(),
        );
    }
  }

  TimeOfDay? getNormalizedTime() {
    if (_type == DateTimePickerType.date) return null;
    return TimeOfDay(
      hour: _hour.toInt(),
      minute: _minute.toInt(),
    );
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