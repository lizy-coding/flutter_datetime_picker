import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/providers/time_picker_provider.dart';
import 'package:provider/provider.dart';

class WheelTimePickerDialog extends StatefulWidget {
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay>? onTimeSelected;

  const WheelTimePickerDialog({
    super.key,
    required this.initialTime,
    this.onTimeSelected,
  });

  @override
  State<WheelTimePickerDialog> createState() => _WheelTimePickerDialogState();
}

class _WheelTimePickerDialogState extends State<WheelTimePickerDialog> {
  late final TimePickerProvider _provider;
  TimeOfDay? _tempTime;
  final FixedExtentScrollController _hourController =
      FixedExtentScrollController();
  final FixedExtentScrollController _minuteController =
      FixedExtentScrollController();

  @override
  void initState() {
    super.initState();
    _provider = TimePickerProvider();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.initialize(widget.initialTime);
      _tempTime = widget.initialTime;
      _hourController.jumpToItem(widget.initialTime.hour);
      _minuteController.jumpToItem(widget.initialTime.minute);
    });
  }

  @override
  void dispose() {
    _provider.dispose();
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  void _handleTimeChanged() {
    _tempTime = TimeOfDay(
      hour: _provider.hour.toInt(),
      minute: _provider.minute.toInt(),
    );
  }

  Widget _buildTimeWheel({
    required FixedExtentScrollController controller,
    required int itemCount,
    required Function(int) onSelectedItemChanged,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_drop_up),
          onPressed: () {
            onIncrement();
            _handleTimeChanged();
          },
          tooltip: '增加$label',
        ),
        SizedBox(
          width: 80,
          height: 160,
          child: ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: 40,
            perspective: 0.005,
            diameterRatio: 1.2,
            physics: const FixedExtentScrollPhysics(),
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: itemCount,
              builder: (context, index) {
                return Center(
                  child: Text(
                    index.toString().padLeft(2, '0'),
                    style: const TextStyle(fontSize: 20),
                    semanticsLabel:
                        '$label: ${index.toString().padLeft(2, '0')}',
                  ),
                );
              },
            ),
            onSelectedItemChanged: (index) {
              try {
                onSelectedItemChanged(index);
                _handleTimeChanged();
              } catch (e) {
                debugPrint('Error updating $label: $e');
              }
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_drop_down),
          onPressed: () {
            onDecrement();
            _handleTimeChanged();
          },
          tooltip: '减少$label',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Dialog(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '选择时间',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTimeWheel(
                    controller: _hourController,
                    itemCount: 24,
                    onSelectedItemChanged: _provider.updateHour,
                    onIncrement: _provider.incrementHour,
                    onDecrement: _provider.decrementHour,
                    label: '小时',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(':', style: TextStyle(fontSize: 30)),
                  ),
                  _buildTimeWheel(
                    controller: _minuteController,
                    itemCount: 60,
                    onSelectedItemChanged: _provider.updateMinute,
                    onIncrement: _provider.incrementMinute,
                    onDecrement: _provider.decrementMinute,
                    label: '分钟',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('取消'),
                  ),
                  TextButton(
                    onPressed: () {
                      try {
                        if (_tempTime != null) {
                          widget.onTimeSelected?.call(_tempTime!);
                        }
                        Navigator.of(context).pop();
                      } catch (e) {
                        debugPrint('Error returning time: $e');
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('确定'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
