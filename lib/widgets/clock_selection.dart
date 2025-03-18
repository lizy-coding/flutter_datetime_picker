import 'dart:math';

import 'package:flutter/material.dart';

class ClockSelection extends CustomPainter {
  final double hour;
  final double minute;

  ClockSelection({
    required this.hour,
    required this.minute,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.8;

    // 绘制时钟外圈
    final circlePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, radius, circlePaint);

    // 绘制刻度
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30 - 90) * (3.14159 / 180);
      final startPoint = Offset(
        center.dx + (radius - 10) * cos(angle),
        center.dy + (radius - 10) * sin(angle),
      );
      final endPoint = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      canvas.drawLine(startPoint, endPoint, circlePaint);
    }

    // 绘制时针
    final hourAngle = (hour * 30 + minute * 0.5 - 90) * (3.14159 / 180);
    final hourPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawLine(
      center,
      Offset(
        center.dx + radius * 0.5 * cos(hourAngle),
        center.dy + radius * 0.5 * sin(hourAngle),
      ),
      hourPaint,
    );

    // 绘制分针
    final minuteAngle = (minute * 6 - 90) * (3.14159 / 180);
    final minutePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawLine(
      center,
      Offset(
        center.dx + radius * 0.7 * cos(minuteAngle),
        center.dy + radius * 0.7 * sin(minuteAngle),
      ),
      minutePaint,
    );
  }

  @override
  bool shouldRepaint(ClockSelection oldDelegate) {
    return oldDelegate.hour != hour || oldDelegate.minute != minute;
  }
}
