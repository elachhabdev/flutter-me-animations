import 'package:flutter/material.dart';

class CurvedPaintWidget extends CustomPainter {
  final double x;
  final double y;
  final double position;

  CurvedPaintWidget({
    required this.x,
    required this.y,
    required this.position,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(colors: [Colors.teal, Colors.green])
          .createShader(Rect.fromCircle(
        center: Offset(size.width * 0.5, size.height * 0.5),
        radius: size.width * 0.5,
      ));

    final path = Path();

    path.moveTo(0.0, position);
    path.quadraticBezierTo(x, y, size.width, position);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CurvedPaintWidget oldDelegate) {
    return oldDelegate.x != x || oldDelegate.y != y;
  }
}
