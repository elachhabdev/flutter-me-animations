import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/models/point.dart';
import 'package:flutter_me_animations/utils/interpolations.dart';

class LinePlot extends CustomPainter {
  final List<Point> points;
  final double x;
  final bool isdragging;
  final Path path;

  LinePlot(
      {required this.points,
      required this.path,
      required this.x,
      required this.isdragging});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = ui.Gradient.linear(Offset(0.0, size.height * 0.5),
          Offset(size.width, size.height * 0.5), [Colors.orange, Colors.cyan])
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final paint2 = Paint()
      ..shader = ui.Gradient.linear(const Offset(0.0, 0.0),
          Offset(0.0, size.height), [Colors.teal, Colors.black])
      ..style = PaintingStyle.fill;

    final List<double> prices = points.map((p) => p.price.abs()).toList();

    final steps = List.generate(
        points.length, (index) => index * (size.width / (points.length - 1)));

    Path path2 = Path.from(path);

    path2
      ..lineTo(size.width, size.height)
      ..lineTo(0.0, size.height);

    canvas.drawPath(path2, paint2);
    canvas.drawPath(path, paint);

    if (isdragging) {
      final paint2 = Paint()
        ..color = Color.lerp(Colors.orange, Colors.cyan, x / size.width)!;
      final paint3 = Paint()..color = Colors.white;
      final paint4 = Paint()..color = Colors.white24;

      final pathMetric = path.computeMetrics().first;

      final totalLength = pathMetric.length;

      double distanceX = totalLength;

      const double precision = 7 / 2;

      for (double distance = 0; distance < totalLength; distance += precision) {
        ui.Tangent? tangent = pathMetric.getTangentForOffset(distance);
        if (tangent != null && tangent.position.dx >= x) {
          distanceX = distance;
          break;
        }
      }

      final tangent = pathMetric.getTangentForOffset(distanceX);

      canvas.drawCircle(tangent!.position, 20, paint4);
      canvas.drawCircle(tangent.position, 14, paint4);
      canvas.drawCircle(tangent.position, 9, paint3);
      canvas.drawCircle(tangent.position, 7, paint2);

      const IconData icon = Icons.monetization_on;

      final textPainter = TextPainter(
          text: TextSpan(
              text:
                  '${interpolate(x, inputRange: steps, outputRange: prices).toStringAsFixed(0)} DH',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              )),
          textDirection: TextDirection.ltr);

      final textIcon = TextPainter(
          text: TextSpan(
              text: String.fromCharCode(icon.codePoint),
              style: TextStyle(
                color: Colors.amber,
                fontFamily: icon.fontFamily,
                fontSize: 18,
              )),
          textDirection: TextDirection.ltr);

      textPainter.layout();
      textIcon.layout();

      if (tangent.position.dx + 80 > size.width - 50) {
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromCenter(
                    center: tangent.position - const Offset(80, 0),
                    width: 100,
                    height: 40),
                const ui.Radius.circular(10)),
            paint3);
        textPainter.paint(
            canvas,
            tangent.position -
                Offset(80 + textPainter.size.width * 0.5 - 5,
                    textPainter.size.height * 0.5));
        textIcon.paint(canvas,
            tangent.position - Offset(80 + 40, textIcon.size.height * 0.5));
      } else {
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromCenter(
                    center: tangent.position + const Offset(80, 0),
                    width: 100,
                    height: 40),
                const ui.Radius.circular(10)),
            paint3);
        textPainter.paint(
            canvas,
            tangent.position +
                Offset(80 - textPainter.size.width * 0.5 + 5,
                    -textPainter.size.height * 0.5));
        textIcon.paint(canvas,
            tangent.position + Offset(80 - 40, -textIcon.size.height * 0.5));
      }
    }
  }

  @override
  bool shouldRepaint(covariant LinePlot oldDelegate) {
    return oldDelegate.x != x ||
        oldDelegate.isdragging != isdragging ||
        oldDelegate.path != path;
  }
}
