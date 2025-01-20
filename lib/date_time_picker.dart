import 'package:flutter/material.dart';
import 'dart:math';

import 'package:time_picker/clock_selection.dart';

class DateTimePicker extends StatefulWidget {
  final DateTime initialDate;
  final TimeOfDay initialTime;
  final ValueChanged<DateTime> onDateTimeChanged;

  const DateTimePicker({
    Key? key,
    required this.initialDate,
    required this.initialTime,
    required this.onDateTimeChanged,
  }) : super(key: key);

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  DateTime? _selectedDate;
  double _hour = 0;
  double _minute = 0;
  String _dateTimeString = '';
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeDateTime();
  }

  void _initializeDateTime() {
    _selectedDate = widget.initialDate;
    _hour = widget.initialTime.hour.toDouble();
    _minute = widget.initialTime.minute.toDouble();
    _updateDateTimeString();
    _updateTimeController();
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _notifyDateTimeChanged();
      });
    }
  }

  void _updateTimeFromInput() {
    final timeParts = _timeController.text.split(':');
    if (timeParts.length == 2) {
      final int? hour = int.tryParse(timeParts[0]);
      final int? minute = int.tryParse(timeParts[1]);
      if (hour != null &&
          minute != null &&
          hour >= 0 &&
          hour < 24 &&
          minute >= 0 &&
          minute < 60) {
        setState(() {
          _hour = hour.toDouble();
          _minute = minute.toDouble();
          _notifyDateTimeChanged();
        });
      }
    }
  }

  void _notifyDateTimeChanged() {
    if (_selectedDate != null) {
      final dateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _hour.toInt(),
        _minute.toInt(),
      ).toUtc();
      widget.onDateTimeChanged(dateTime);
      _updateDateTimeString();
      _updateTimeController(); // Ensure the time controller is updated
    }
  }

  void _updateDateTimeString() {
    if (_selectedDate != null) {
      final dateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _hour.toInt(),
        _minute.toInt(),
      ).toLocal();
      _dateTimeString = dateTime.toString();
    }
  }

  void _updateTimeController() {
    _timeController.text =
        '${_hour.toInt().toString().padLeft(2, '0')}:${_minute.toInt().toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Date and Time Picker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(child: _buildDateSelector()),
            const SizedBox(width: 20),
            Expanded(child: _buildTimeSelector()),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          _selectedDate == null
              ? 'No date selected!'
              : 'Selected Date: ${_selectedDate!.toLocal()}'.split(' ')[0],
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _selectDate,
          child: const Text('Select date'),
        ),
      ],
    );
  }

  Widget _buildTimeSelector() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _timeController,
          decoration: const InputDecoration(
            labelText: 'Enter time (HH:MM)',
          ),
          keyboardType: TextInputType.datetime,
          onSubmitted: (_) => _updateTimeFromInput(),
          onEditingComplete: _updateTimeFromInput,
        ),
        const SizedBox(height: 20),
        CustomPaint(
          size: const Size(200, 200),
          painter: ClockSelection(hour: _hour, minute: _minute),
        ),
      ],
    );
  }
}
