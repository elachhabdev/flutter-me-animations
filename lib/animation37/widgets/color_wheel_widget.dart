import 'dart:ui';

import 'package:flutter/material.dart';

class ColorWheelWidget extends CustomPainter {
  final FragmentShader shader;
  ColorWheelWidget({required this.shader});

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);

    final paint = Paint()..shader = shader;

    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
