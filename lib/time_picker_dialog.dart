import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_picker/time_picker_provider.dart';

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

  @override
  void initState() {
    super.initState();
    _provider = TimePickerProvider();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.initialize(widget.initialTime);
    });
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  void _handleTimeSelected() {
    final selectedTime = TimeOfDay(
      hour: _provider.hour.toInt(),
      minute: _provider.minute.toInt(),
    );
    widget.onTimeSelected?.call(selectedTime);
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
            _handleTimeSelected();
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
                    semanticsLabel: '$label: ${index.toString().padLeft(2, '0')}',
                  ),
                );
              },
            ),
            onSelectedItemChanged: (index) {
              try {
                onSelectedItemChanged(index);
                _handleTimeSelected();
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
            _handleTimeSelected();
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
                    controller: _provider.hourController,
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
                    controller: _provider.minuteController,
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
                        _handleTimeSelected();
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