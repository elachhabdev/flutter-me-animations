import 'dart:math';

import 'package:flutter/material.dart';

class CircleShape extends CustomPainter {
  double angle;

  CircleShape({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()..color = Colors.white;
    final paint3 = Paint()..color = Colors.purple.shade900;

    canvas.drawCircle(
        Offset(size.width * 0.5 - 14, size.height / 2), 14, paint1);

    final x = 10 * cos(angle);
    final y = 10 * sin(angle);

    canvas.drawCircle(
        Offset(size.width * 0.5 - 14, size.height / 2) + Offset(x, y),
        10,
        paint3);
  }

  @override
  bool shouldRepaint(covariant CircleShape oldDelegate) {
    return oldDelegate.angle != angle;
  }
}

class OvalShap extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint2 = Paint()..color = Colors.purple;
    final paint = Paint()..color = Colors.purple.shade900;

    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: size.width + 20,
            height: size.height + 20),
        paint);

    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: size.width,
            height: size.height),
        paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
