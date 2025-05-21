import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_me_animations/models/circle_particle.dart';

class Animation50Screen extends StatefulWidget {
  const Animation50Screen({super.key});

  @override
  State<Animation50Screen> createState() => _Animation50ScreenState();
}

class _Animation50ScreenState extends State<Animation50Screen>
    with SingleTickerProviderStateMixin {
  final List<CircleParticle> circles = [];

  final int radiusCircle = 20;

  Offset pointer = Offset.zero;

  Ticker? ticker;

  DateTime? lastMouvementTime;

  Duration lastTick = Duration.zero;

  double get screenPixelRatio =>
      PlatformDispatcher.instance.views.first.devicePixelRatio;

  double get screenWidthPixels =>
      PlatformDispatcher.instance.views.first.physicalSize.shortestSide;

  double get screenHeightPixels =>
      PlatformDispatcher.instance.views.first.physicalSize.longestSide;

  double get width => (screenWidthPixels / screenPixelRatio);

  double get height => (screenHeightPixels / screenPixelRatio);

  final List<String> words = 'ELACHHAB'.split('');

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < words.length; i++) {
      circles.add(CircleParticle(
        index: i,
        color: Color.fromRGBO(Random().nextInt(255), Random().nextInt(255),
            Random().nextInt(255), 1.0),
        current: Offset(width * 0.5, height * 0.5),
        radius: i == 0 ? 35 : 30,
      ));
    }

    ticker ??= createTicker((elapsed) {
      final Duration deltaTime = elapsed - lastTick;

      final deltaTimeMS = deltaTime.inMilliseconds / 1000;

      lastTick = elapsed;

      setState(() {
        circles[0].setCurrentPosition(pointer);

        for (int i = 1; i < circles.length; i++) {
          final deltaFactor = lerpDouble(8.0, 4.0, (i) / (circles.length - 1))!;
          circles[i].updateCurrentPosition(circles[i - 1].current,
              circles[i].color, 30, 1 - exp(-deltaFactor * deltaTimeMS));
        }
      });

      if (lastMouvementTime != null) {
        final now = DateTime.now();
        if (now.difference(lastMouvementTime!) > const Duration(seconds: 5)) {
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
    final Size size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: GestureDetector(
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
          },
          child: CustomPaint(
            size: const Size(30, 30),
            painter:
                CustomCircles(circles: circles, pointer: pointer, words: words),
          ),
        ),
      ),
    );
  }
}

class CustomCircles extends CustomPainter {
  final List<CircleParticle> circles;

  final Offset pointer;

  final int radiusCircle = 20;

  final List<String> words;

  const CustomCircles(
      {required this.circles, required this.pointer, required this.words});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = circles.length - 1; i >= 1; i--) {
      paint.color = circles[i].color;
      canvas.drawCircle(circles[i].current, circles[i].radius, paint);
      final text = TextPainter(
        text: TextSpan(
            text: words[i], style: const TextStyle(color: Colors.white)),
        textDirection: TextDirection.ltr,
      );

      text.layout();

      text.paint(
          canvas,
          Offset(circles[i].current.dx - text.width * 0.5,
              circles[i].current.dy - text.height * 0.5));
    }

    paint.color = circles[0].color;

    canvas.drawCircle(circles[0].current, circles[0].radius, paint);

    final text = TextPainter(
      text: const TextSpan(text: 'ME', style: TextStyle(color: Colors.white)),
      textDirection: TextDirection.ltr,
    );

    text.layout();

    text.paint(
        canvas,
        Offset(circles[0].current.dx - text.width * 0.5,
            circles[0].current.dy - text.height * 0.5));
  }

  @override
  bool shouldRepaint(covariant CustomCircles oldDelegate) {
    return true;
  }
}
