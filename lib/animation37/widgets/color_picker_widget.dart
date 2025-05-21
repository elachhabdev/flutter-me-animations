import 'package:flutter/material.dart';
import 'package:flutter_me_animations/utils/color_hue.dart';

class ColorPickerWidget extends CustomPainter {
  final double hue;
  final double saturation;

  ColorPickerWidget({required this.saturation, required this.hue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint3 = Paint()..color = Colors.black12;

    double width2 = 40.0;
    double height2 = 60.0;

    final path2 = Path()
      ..moveTo(0.0, height2 * 0.5)
      ..cubicTo(0.0, 0.0, width2, 0.0, width2, height2 * 0.5)
      ..cubicTo(
          width2, height2 * 0.8, width2 * 0.5, height2, width2 * 0.5, height2)
      ..cubicTo(width2 * 0.5, height2, 0.0, height2 * 0.8, 0.0, height2 * 0.5);

    canvas.translate(0.0, -7.0);

    canvas.drawPath(path2, paint3);

    final paint2 = Paint()..color = Colors.white;

    double width1 = 36.0;
    double height1 = 56.0;

    final path = Path()
      ..moveTo(0.0, height1 * 0.5)
      ..cubicTo(0.0, 0.0, width1, 0.0, width1, height1 * 0.5)
      ..cubicTo(
          width1, height1 * 0.8, width1 * 0.5, height1, width1 * 0.5, height1)
      ..cubicTo(width1 * 0.5, height1, 0.0, height1 * 0.8, 0.0, height1 * 0.5);

    canvas.translate(2.0, 2.0);

    canvas.drawPath(path, paint2);

    canvas.save();

    final paint1 = Paint()..color = hsv2rgb(hue, saturation * saturation, 1.0);

    double width = 30.0;
    double height = 50.0;

    final path1 = Path()
      ..moveTo(0.0, height * 0.5)
      ..cubicTo(0.0, 0.0, width, 0.0, width, height * 0.5)
      ..cubicTo(width, height * 0.8, width * 0.5, height, width * 0.5, height)
      ..cubicTo(width * 0.5, height, 0.0, height * 0.8, 0.0, height * 0.5);

    canvas.translate(3.0, 3.0);

    canvas.drawPath(path1, paint1);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant ColorPickerWidget oldDelegate) {
    return oldDelegate.hue != hue || oldDelegate.saturation != saturation;
  }
}
