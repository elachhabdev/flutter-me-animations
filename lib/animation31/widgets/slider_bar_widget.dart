import 'package:flutter/material.dart';

class SliderBar extends CustomPainter {
  double value = 0.0;

  SliderBar({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    final paint2 = Paint()
      ..color = Colors.indigo.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final path1 = Path()
      ..moveTo(0.0, size.height * 0.5)
      ..lineTo(size.width, size.height * 0.5);
    final path2 = Path()
      ..moveTo(0.0, size.height * 0.5)
      ..lineTo(size.width * value, size.height * 0.5);

    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant SliderBar oldDelegate) {
    return oldDelegate.value != value;
  }
}
