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
    final hourAngle = (pi / 6) * hour;
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

    // Draw hour markers
    for (int i = 1; i <= 12; i++) {
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
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
