import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation33/animation33_screen.dart';

class ArrowPainter extends CustomPainter {
  Offset currentCircle = Offset.zero;
  final List<Particle> particles;
  final Offset origin;
  final double circle;
  final Size itemSize;
  ArrowPainter(
      {required this.currentCircle,
      required this.particles,
      required this.origin,
      required this.circle,
      required this.itemSize});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..color = Colors.cyan;

    for (int i = 0; i < particles.length; i++) {
      canvas.save();

      final double xP = particles[i].position.dx;
      final double yP = particles[i].position.dy;

      final Offset positionfromCenter = currentCircle + origin;

      final Offset cm =
          Offset(positionfromCenter.dx - xP, yP - positionfromCenter.dy);

      final double angle = atan2(cm.dx, cm.dy);

      //y is inversed in canvas

      final double distance = (1 -
              ((cm.distance - circle * 0.5 - itemSize.width * 0.5) /
                  (itemSize.width * 0.5)))
          .clamp(0.0, 1.0);

      final paint2 = Paint()
        ..color = Color.lerp(Colors.purple, Colors.yellow, distance)!;

      canvas.translate(particles[i].position.dx, particles[i].position.dy);

      canvas.rotate(angle);

      canvas.translate(-particles[i].position.dx, -particles[i].position.dy);

      canvas.drawLine(
          particles[i].position + Offset(0.0, itemSize.height * 0.5),
          particles[i].position +
              Offset(0.0, lerpDouble(0.0, -itemSize.height * 0.3, distance)!),
          paint);

      canvas.drawCircle(
          particles[i].position +
              Offset(0.0, lerpDouble(0.0, -itemSize.height * 0.4, distance)!),
          lerpDouble(5.0, 10.0, distance)!,
          paint2);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ArrowPainter oldDelegate) {
    return oldDelegate.currentCircle != currentCircle;
  }
}
