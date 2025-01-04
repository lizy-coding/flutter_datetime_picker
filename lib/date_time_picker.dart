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

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _hour = widget.initialTime.hour.toDouble();
    _minute = widget.initialTime.minute.toDouble();
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _notifyDateTimeChanged();
      });
    }
  }

  void _updateTime(Offset offset, Size size) {
    final center = size.center(Offset.zero);
    final angle = atan2(offset.dy - center.dy, offset.dx - center.dx);
    final degrees = angle * 180 / pi;
    final adjustedDegrees = (degrees + 360) % 360;

    setState(() {
      double newMinute = (adjustedDegrees / 6).roundToDouble();
      if (newMinute == 0 && _minute == 59) {
        _hour = (_hour + 1) % 12; // Increment hour when minute wraps around
      } else if (newMinute == 59 && _minute == 0) {
        _hour = (_hour - 1 + 12) % 12; // Decrement hour when minute wraps back
      }
      _minute = newMinute;
      _notifyDateTimeChanged();
    });
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Date and Time Picker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Date Display and Picker
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  _selectedDate == null
                      ? 'No date selected!'
                      : 'Selected Date: ${_selectedDate!.toLocal()}'
                          .split(' ')[0],
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _selectDate,
                  child: const Text('Select date'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Time Display
            Text(
              'Selected Time: ${_hour.toInt().toString().padLeft(2, '0')}:${_minute.toInt().toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            // Time Picker
            GestureDetector(
              onPanUpdate: (details) {
                RenderBox box = context.findRenderObject() as RenderBox;
                Offset localPosition =
                    box.globalToLocal(details.globalPosition);
                _updateTime(localPosition, box.size);
              },
              onTapUp: (details) {
                RenderBox box = context.findRenderObject() as RenderBox;
                Offset localPosition =
                    box.globalToLocal(details.globalPosition);
                _updateTime(localPosition, box.size);
              },
              child: CustomPaint(
                size: const Size(200, 200), // Adjusted size for better layout
                painter: ClockSelection(hour: _hour, minute: _minute),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
