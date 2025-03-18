import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/providers/date_time_picker_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/widgets/clock_selection.dart';
import 'package:flutter_datetime_picker/widgets/time_picker_dialog.dart';
import 'package:flutter_datetime_picker/models/date_time_picker_type.dart';

class DateTimePicker extends StatefulWidget {
  final DateTime initialDate;
  final TimeOfDay initialTime;
  final ValueChanged<DateTime> onDateTimeChanged;
  final ValueChanged<TimeOfDay> onTimeChanged;
  final DateTimePickerType type;

  const DateTimePicker({
    super.key,
    required this.initialDate,
    required this.initialTime,
    required this.onDateTimeChanged,
    required this.onTimeChanged,
    this.type = DateTimePickerType.datetime,
  });

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  late final DateTimePickerProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = DateTimePickerProvider(type: widget.type);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.initialize(widget.initialDate, widget.initialTime);
    });
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  void _selectDate() async {
    if (widget.type == DateTimePickerType.time) return;

    FocusScope.of(context).unfocus();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _provider.selectedDate ?? DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _provider.updateDate(picked);
      _notifyDateTimeChanged();
    }
  }

  void _selectTime() async {
    if (widget.type == DateTimePickerType.date) return;

    await showDialog<void>(
      context: context,
      builder: (context) => WheelTimePickerDialog(
        initialTime: TimeOfDay(
          hour: _provider.hour.toInt(),
          minute: _provider.minute.toInt(),
        ),
        onTimeSelected: (time) {
          _provider.updateTime(time);
          _notifyDateTimeChanged();
        },
      ),
    );
  }

  void _notifyDateTimeChanged() {
    final normalizedDateTime = _provider.getNormalizedDateTime();
    final normalizedTime = _provider.getNormalizedTime();

    if (normalizedDateTime != null) {
      widget.onDateTimeChanged(normalizedDateTime);
    }

    if (normalizedTime != null) {
      widget.onTimeChanged(normalizedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_getTitle()),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (widget.type != DateTimePickerType.time)
                Expanded(child: _buildDateSelector()),
              if (widget.type != DateTimePickerType.date) ...[
                if (widget.type != DateTimePickerType.time)
                  const SizedBox(width: 20),
                Expanded(child: _buildTimeSelector()),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    switch (widget.type) {
      case DateTimePickerType.date:
        return '日期选择器';
      case DateTimePickerType.time:
        return '时间选择器';
      case DateTimePickerType.datetime:
        return '日期时间选择器';
    }
  }

  Widget _buildDateSelector() {
    return Consumer<DateTimePickerProvider>(
      builder: (context, provider, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              provider.selectedDate == null
                  ? '未选择日期'
                  : '${provider.selectedDate!.year}年${provider.selectedDate!.month.toString().padLeft(2, '0')}月${provider.selectedDate!.day.toString().padLeft(2, '0')}日',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _selectDate,
              child: const Text('选择日期'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTimeSelector() {
    return Consumer<DateTimePickerProvider>(
      builder: (context, provider, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300,
              child: TextField(
                controller: provider.timeController,
                readOnly: true,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: '选择时间',
                  suffixIcon: Icon(Icons.access_time),
                ),
                onTap: _selectTime,
              ),
            ),
            const SizedBox(height: 20),
            CustomPaint(
              size: const Size(200, 200),
              painter: ClockSelection(
                hour: provider.hour,
                minute: provider.minute,
              ),
            ),
          ],
        );
      },
    );
  }
}
