import 'dart:math';

import 'package:flutter/material.dart';

class ThreeArc extends CustomPainter {
  final Color color;
  final double containerImage;

  ThreeArc({required this.color, required this.containerImage});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);

    final gradient = LinearGradient(colors: [
      color.withValues(alpha: 0.1),
      color,
    ]);

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    final paintstart = Paint()
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 6.0
      ..style = PaintingStyle.fill
      ..color = color;

    final paintend = Paint()
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 6.0
      ..style = PaintingStyle.fill
      ..color = color;

    final paint2 = Paint()
      ..color = Colors.blueGrey.shade200
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final paint3 = Paint()
      ..color = Colors.blueGrey.shade200
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;

    const double padding = 50;

    final double raduisWithoutPadding = containerImage * 0.5;

    final double radius = (containerImage + padding) * 0.5;

    canvas.drawArc(
        Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: size.width + padding,
            height: size.height + padding),
        pi / 2 + pi / 3,
        pi / 3,
        false,
        paint2);

    canvas.drawCircle(
        Offset(raduisWithoutPadding + radius * cos(-pi / 2 - pi / 3),
            raduisWithoutPadding + radius * sin(-pi / 2 - pi / 3)),
        4.0,
        paint3);

    canvas.drawCircle(
        Offset(raduisWithoutPadding + radius * cos(-pi / 2 - 2 * pi / 3),
            raduisWithoutPadding + radius * sin(-pi / 2 - 2 * pi / 3)),
        4.0,
        paint3);

    canvas.drawArc(
        Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: size.width + padding,
            height: size.height + padding),
        pi + pi / 3,
        pi / 2,
        false,
        paint);

    canvas.drawArc(
        Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: size.width + padding,
            height: size.height + padding),
        pi / 5,
        pi / 2,
        false,
        paint);

    canvas.drawCircle(
        Offset(raduisWithoutPadding + radius * cos(pi / 5),
            raduisWithoutPadding + radius * sin(pi / 5)),
        4.0,
        paintend);

    canvas.drawCircle(
        Offset(raduisWithoutPadding + radius * cos(pi / 5 + pi / 2),
            raduisWithoutPadding + radius * sin(pi / 5 + pi / 2)),
        4.0,
        paintstart);

    canvas.drawCircle(
        Offset(
            raduisWithoutPadding +
                radius *
                    cos(
                      pi + pi / 3,
                    ),
            raduisWithoutPadding +
                radius *
                    sin(
                      pi + pi / 3,
                    )),
        4.0,
        paintend);

    canvas.drawCircle(
        Offset(
            raduisWithoutPadding +
                radius *
                    cos(
                      pi + pi / 3 + pi / 2,
                    ),
            raduisWithoutPadding +
                radius *
                    sin(
                      pi + pi / 3 + pi / 2,
                    )),
        4.0,
        paintend);

    canvas.drawCircle(
        Offset(raduisWithoutPadding + radius * cos(pi / 5 + pi / 2),
            raduisWithoutPadding + radius * sin(pi / 5 + pi / 2)),
        4.0,
        paintstart);
  }

  @override
  bool shouldRepaint(covariant ThreeArc oldDelegate) =>
      oldDelegate.color != color;
}
