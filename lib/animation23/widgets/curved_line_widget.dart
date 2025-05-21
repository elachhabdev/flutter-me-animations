import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter_me_animations/utils/interpolations.dart';

class CurvedLineCustom extends CustomPainter {
  final double percent;

  CurvedLineCustom({required this.percent});

  @override
  void paint(Canvas canvas, Size size) {
    const heightofcurve = 60.0;

    final paint = Paint()
      ..shader = ui.Gradient.linear(const Offset(0.0, 0.0),
          Offset(0.0, size.height), [Colors.purple, Colors.blue])
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    final paint1 = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final paint2 = Paint()
      ..color = Colors.blueGrey.shade50
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final heightPercent = size.height * percent;

    const middleCurve = heightofcurve * 0.5;

    final path = Path()
      ..lineTo(0.0, heightPercent - heightofcurve)
      ..cubicTo(0.0, heightPercent - middleCurve, -middleCurve,
          heightPercent - middleCurve, -middleCurve, heightPercent)
      ..cubicTo(-middleCurve, heightPercent + middleCurve, 0.0,
          heightPercent + middleCurve, 0.0, heightPercent + heightofcurve)
      ..lineTo(0.0, size.height);

    canvas.drawPath(path, paint);

    final pathMetric = path.computeMetrics().first;

    double distance = size.height * 0.1;

    double gap = (size.height * 0.8) / 45;

    while (distance <= size.height * 0.9) {
      final tangent = pathMetric.getTangentForOffset(distance);
      final x = tangent!.position.dx;
      final y = tangent.position.dy;

      canvas.drawPath(
          Path()
            ..moveTo(x - 15, y)
            ..lineTo(x - 30, y),
          paint2);

      distance += gap;
    }

    distance = size.height * 0.1;

    gap = (size.height * 0.8) / 9;

    int index = 0;

    final indexPercent = inverselerp(0.1, 0.9, percent) * 9;

    while (distance < size.height * 0.9 + heightofcurve * 0.5) {
      final tangent = pathMetric.getTangentForOffset(distance);
      final x = tangent!.position.dx;
      final y = tangent.position.dy;

      final textPercent = (indexPercent - index).abs().clamp(0.0, 1.0);

      final text = TextPainter(
          text: TextSpan(
              text: '${(((9 - index) / 9) * 100).truncate()} %',
              style: TextStyle(
                  color: Color.lerp(Colors.blue, Colors.white, textPercent))),
          textDirection: TextDirection.ltr,
          textScaler: TextScaler.linear(ui.lerpDouble(2.5, 1.0, textPercent)!));

      text.layout();

      text.paint(
          canvas,
          Offset(x - text.width * 0.5, y - text.height * 0.5) -
              Offset(size.width * 0.5, 0.0));

      canvas.drawPath(
          Path()
            ..moveTo(x - 15, y)
            ..lineTo(x - 40, y),
          paint1);

      distance += gap;
      index++;
    }
  }

  @override
  bool shouldRepaint(covariant CurvedLineCustom oldDelegate) {
    return oldDelegate.percent != percent;
  }
}
