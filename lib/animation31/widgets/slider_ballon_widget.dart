import 'dart:ui';

import 'package:flutter/material.dart';

class SliderBallon extends CustomPainter {
  double value = 0.0;
  double x = 0.0;

  SliderBallon({required this.value, required this.x});
  @override
  void paint(Canvas canvas, Size size) {
    final text = lerpDouble(0, 100, x)!.toInt();

    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 14,
    );

    final textSpan = TextSpan(
      text: text.toString(),
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final paint4 = Paint()
      ..color = Colors.indigo.shade800
      ..style = PaintingStyle.fill;

    final y = size.width * 1.1;

    canvas.drawCircle(Offset(size.width * 0.5, lerpDouble(0.0, -y, value)!),
        size.width * 0.8, paint4);
    canvas.drawCircle(Offset(size.width * 0.5, lerpDouble(0.0, 0, value)!),
        size.width * 0.12, paint4);

    textPainter.layout();

    final textX = (textPainter.width) / 2;
    final textY = (textPainter.height) / 2;

    final offset =
        Offset(size.width * 0.5 - textX, -y - size.width * 0.5 + textY);

    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant SliderBallon oldDelegate) {
    return oldDelegate.x != x || oldDelegate.value != value;
  }
}
