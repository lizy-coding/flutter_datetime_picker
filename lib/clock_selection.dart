import 'dart:math';

import 'package:flutter/material.dart';

class ClockSelection extends CustomPainter {
  final double hour;
  final double minute;

  ClockSelection({required this.hour, required this.minute});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    // Draw clock circle
    canvas.drawCircle(center, radius, paint);

    // Draw hour hand
    final hourAngle =
        (pi / 6) * (hour % 12 + minute / 60); // Ensure 12-hour format
    final hourHandLength = radius * 0.5;
    final hourHandOffset = Offset(
      hourHandLength * cos(hourAngle - pi / 2),
      hourHandLength * sin(hourAngle - pi / 2),
    );
    canvas.drawLine(center, center + hourHandOffset, paint);

    // Draw minute hand
    final minuteAngle = (pi / 30) * minute;
    final minuteHandLength = radius * 0.7;
    final minuteHandOffset = Offset(
      minuteHandLength * cos(minuteAngle - pi / 2),
      minuteHandLength * sin(minuteAngle - pi / 2),
    );
    canvas.drawLine(center, center + minuteHandOffset, paint);

    // Draw hour markers and Roman numerals
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    const romanNumerals = [
      'XII',
      'I',
      'II',
      'III',
      'IV',
      'V',
      'VI',
      'VII',
      'VIII',
      'IX',
      'X',
      'XI'
    ];

    for (int pointerIndex = 0; pointerIndex < 12; pointerIndex++) {
      final angle = (pi / 6) * pointerIndex;
      final markerLength =
          pointerIndex % 3 == 0 ? 15.0 : 10.0; // Longer markers for 3, 6, 9, 12
      final startOffset = Offset(
        (radius - markerLength) * cos(angle - pi / 2),
        (radius - markerLength) * sin(angle - pi / 2),
      );
      final endOffset = Offset(
        radius * cos(angle - pi / 2),
        radius * sin(angle - pi / 2),
      );
      canvas.drawLine(center + startOffset, center + endOffset, paint);

      // Draw Roman numerals
      final numeralOffset = Offset(
        (radius - 30) * cos(angle - pi / 2),
        (radius - 30) * sin(angle - pi / 2),
      );
      textPainter.text = TextSpan(
        text: romanNumerals[pointerIndex],
        style: const TextStyle(color: Colors.black, fontSize: 16),
      );
      textPainter.layout();
      textPainter.paint(
          canvas,
          center +
              numeralOffset -
              Offset(textPainter.width / 2, textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
