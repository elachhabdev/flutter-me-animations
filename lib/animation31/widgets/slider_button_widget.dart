import 'dart:ui';

import 'package:flutter/material.dart';

class SliderButton extends CustomPainter {
  double value = 0.0;
  SliderButton({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final paint3 = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final paint4 = Paint()
      ..color = Colors.indigo.shade800
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.5),
        lerpDouble(size.width * 0.5, size.width * 0.6, value)!, paint4);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.5),
        lerpDouble(size.width * 0.5 * 0.5, size.width * 0.5, value)!, paint3);
  }

  @override
  bool shouldRepaint(covariant SliderButton oldDelegate) {
    return oldDelegate.value != value;
  }
}
