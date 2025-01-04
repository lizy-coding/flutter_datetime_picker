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
        (pi / 6) * hour + (pi / 360) * minute; // Adjust hour hand with minute
    final hourHandLength = radius * 0.5;
    final hourHandOffset = Offset(
      hourHandLength * cos(hourAngle),
      hourHandLength * sin(hourAngle),
    );
    canvas.drawLine(center, center + hourHandOffset, paint);

    // Draw minute hand
    final minuteAngle = (pi / 30) * minute;
    final minuteHandLength = radius * 0.7;
    final minuteHandOffset = Offset(
      minuteHandLength * cos(minuteAngle),
      minuteHandLength * sin(minuteAngle),
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

    for (int i = 0; i < 12; i++) {
      final angle = (pi / 6) * i;
      final markerLength =
          i % 3 == 0 ? 15.0 : 10.0; // Longer markers for 3, 6, 9, 12
      final startOffset = Offset(
        (radius - markerLength) * cos(angle),
        (radius - markerLength) * sin(angle),
      );
      final endOffset = Offset(
        radius * cos(angle),
        radius * sin(angle),
      );
      canvas.drawLine(center + startOffset, center + endOffset, paint);

      // Draw Roman numerals
      final numeralOffset = Offset(
        (radius - 30) * cos(angle),
        (radius - 30) * sin(angle),
      );
      textPainter.text = TextSpan(
        text: romanNumerals[i],
        style: TextStyle(color: Colors.black, fontSize: 16),
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
