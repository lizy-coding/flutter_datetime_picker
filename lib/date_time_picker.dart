import 'package:flutter/material.dart';
import 'dart:math';
import 'package:time_picker/clock_selection.dart';

class DateTimePicker extends StatefulWidget {
  final DateTime initialDate;
  final TimeOfDay initialTime;
  final ValueChanged<DateTime> onDateTimeChanged;

  const DateTimePicker({
    super.key,
    required this.initialDate,
    required this.initialTime,
    required this.onDateTimeChanged,
  });

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

  Future<void> _selectDate(BuildContext context) async {
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
      _hour = (adjustedDegrees / 30).floorToDouble();
      _minute = ((adjustedDegrees % 30) / 0.5).floorToDouble();
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
      );
      widget.onDateTimeChanged(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Date and Time Picker'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Date Picker
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                _selectedDate == null
                    ? 'No date selected!'
                    : 'Selected Date: ${_selectedDate!.toLocal()}'
                        .split(' ')[0],
              ),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: const Text('Select date'),
              ),
            ],
          ),
          const SizedBox(width: 20),
          // Time Picker
          GestureDetector(
            onPanUpdate: (details) {
              RenderBox box = context.findRenderObject() as RenderBox;
              Offset localPosition = box.globalToLocal(details.globalPosition);
              _updateTime(localPosition, box.size);
            },
            child: CustomPaint(
              size: const Size(300, 300),
              painter: ClockSelection(hour: _hour, minute: _minute),
            ),
          ),
        ],
      ),
    );
  }
}
