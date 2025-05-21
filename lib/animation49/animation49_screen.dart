import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_me_animations/models/particle.dart';

class Animation49Screen extends StatefulWidget {
  const Animation49Screen({super.key});

  @override
  State<Animation49Screen> createState() => _Animation49ScreenState();
}

class _Animation49ScreenState extends State<Animation49Screen>
    with SingleTickerProviderStateMixin {
  double get screenPixelRatio =>
      PlatformDispatcher.instance.views.first.devicePixelRatio;

  double get screenWidthPixels =>
      PlatformDispatcher.instance.views.first.physicalSize.shortestSide;

  double get screenHeightPixels =>
      PlatformDispatcher.instance.views.first.physicalSize.longestSide;

  double get width => (screenWidthPixels / screenPixelRatio);

  double get height => (screenHeightPixels / screenPixelRatio);

  final List<Particle> particles = [];

  final int radiusCircle = 20;

  final int radiusPointer = 50;

  Offset pointer = Offset.zero;

  Ticker? ticker;

  DateTime? lastMouvementTime;

  Duration lastTick = Duration.zero;

  @override
  void initState() {
    super.initState();

    int stepX = ((width) / 18).truncate();
    int stepY = ((height) / 30).truncate();

    for (double x = 0; x <= width + stepX; x += stepX) {
      for (double y = 0; y <= height + stepY; y += stepY) {
        particles.add(Particle(
            color: Colors.black,
            current: Offset(x.toDouble(), y.toDouble()),
            initial: Offset(x.toDouble(), y.toDouble())));
      }
    }
    ticker ??= createTicker((elapsed) {
      final Duration deltaTime = elapsed - lastTick;

      final deltaTimeMS = deltaTime.inMilliseconds / 1000;

      lastTick = elapsed;

      setState(() {
        for (int i = 0; i < particles.length; i++) {
          if ((particles[i].initial - pointer).distance <= radiusPointer) {
            double angle = atan2(
                (particles[i].current.dy + radiusCircle * 0.5 - pointer.dy),
                (particles[i].current.dx + radiusCircle * 0.5 - pointer.dx));

            double r = (particles[i].current - pointer).distance;

            final target = particles[i].current +
                Offset((radiusPointer - r) * cos(angle),
                    (radiusPointer - r) * sin(angle));

            particles[i].updateCurrentPosition(
                target, Colors.green, 1 - exp(-8 * deltaTimeMS));
          } else {
            final target = particles[i].initial;

            if (particles[i].initial != particles[i].current) {
              particles[i].updateCurrentPosition(
                  target, Colors.black, 1 - exp(-4 * deltaTimeMS));
            }
          }
        }
      });

      if (lastMouvementTime != null) {
        final now = DateTime.now();
        if (now.difference(lastMouvementTime!) > const Duration(seconds: 2)) {
          lastMouvementTime = null;
          lastTick = Duration.zero;
          ticker!.stop();
        }
      }
    });
  }

  startAnimation() {
    if (ticker != null) {
      if (!ticker!.isActive) {
        ticker!.start();
      }
    }
  }

  @override
  void dispose() {
    ticker?.dispose();
    ticker = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanStart: (details) {
          pointer = details.localPosition;
          lastMouvementTime = DateTime.now();

          startAnimation();
        },
        onPanUpdate: (details) {
          lastMouvementTime = DateTime.now();

          pointer = details.localPosition;
        },
        onPanEnd: (details) {
          lastMouvementTime = DateTime.now();

          pointer = Offset.infinite;
        },
        child: CustomPaint(
          size: Size(width, height),
          painter: CustomCircle(particles: particles, pointer: pointer),
        ),
      ),
    );
  }
}

class CustomCircle extends CustomPainter {
  final List<Particle> particles;

  final Offset pointer;

  final int radiusCircle = 20;

  const CustomCircle({required this.particles, required this.pointer});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < particles.length; i++) {
      paint.color = particles[i].color;
      canvas.drawCircle(particles[i].current, radiusCircle * 0.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomCircle oldDelegate) {
    return true;
  }
}
