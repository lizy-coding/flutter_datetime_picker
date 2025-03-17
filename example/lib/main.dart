import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:time_picker/date_time_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DateTimePicker(
        initialDate: DateTime.now(),
        initialTime: TimeOfDay.now(),
        onDateTimeChanged: (dateTime) {
          if (kDebugMode) {
            print(dateTime);
          }
        },
        onTimeChanged: (time) {
          if (kDebugMode) {
            print(time);
          }
        },
      ),
    );
  }
}
