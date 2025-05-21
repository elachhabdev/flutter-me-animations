import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class Animation35Screen extends StatefulWidget {
  const Animation35Screen({super.key});

  @override
  State<Animation35Screen> createState() => _Animation35ScreenState();
}

class _Animation35ScreenState extends State<Animation35Screen>
    with SingleTickerProviderStateMixin {
  late double height;

  late double width;

  late double gap;

  late double fem;

  late double containerWidth;

  late double radius;

  late double circle;

  final ValueNotifier<double> page = ValueNotifier(0.0);

  final ValueNotifier<double> translateX = ValueNotifier(0.0);

  late AnimationController animationController;

  decay() {
    translateX.value = animationController.value
        .clamp(0.0, circle - ((containerWidth - gap) * 2.5));

    page.value = (translateX.value / (containerWidth - gap));
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController.unbounded(vsync: this);
    animationController.addListener(decay);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Size size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    fem = width / AppUtils.baseWidth;
    containerWidth = width / 3;
    radius = width;
    circle = 2 * pi * (radius);
    gap = 50 * fem;
  }

  @override
  void dispose() {
    page.dispose();
    translateX.dispose();
    animationController.removeListener(decay);
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int rows = (circle / (containerWidth - gap)).floor() - 1;
    return Scaffold(
        body: SafeArea(
      child: GestureDetector(
        onPanStart: (details) {
          if (animationController.isAnimating) {
            animationController.stop();
          }
        },
        onPanUpdate: (details) {
          translateX.value = (translateX.value + details.delta.dx)
              .clamp(0.0, circle - (containerWidth - gap) * 2.5);
          page.value = (translateX.value / (containerWidth - gap));
        },
        onPanEnd: (details) {
          final velocity = details.velocity.pixelsPerSecond;

          final frictionSimulation =
              FrictionSimulation(0.4, translateX.value, velocity.dx * 0.4);

          double snap =
              ((frictionSimulation.finalX / (containerWidth - gap)).floor() *
                  (containerWidth - gap));

          final springsimulation = SpringSimulation(
              SpringDescription.withDampingRatio(
                mass: 1.0,
                stiffness: 1000.0,
                ratio: 5.0,
              ),
              translateX.value,
              snap,
              velocity.dx);

          animationController.animateWith(springsimulation);
        },
        child: Stack(
          children: [
            AnimatedBuilder(
                animation: page,
                builder: (context, child) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor:
                          Colors.purple.withGreen(((e / 32) * 255).toInt()),
                      child: Text(
                        page.value.toStringAsFixed(0),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  );
                }),
            ...List.generate(rows, (index) => index).reversed.map((e) {
              return AnimatedBuilder(
                  animation: page,
                  child: RepaintBoundary(
                    child: Transform.rotate(
                      angle: pi / 2,
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.indigo
                                .withGreen(((e / 32) * 255).toInt()),
                            child: Text(
                              '$e',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ),
                          SizedBox(
                            height: 10 * fem,
                          ),
                          SizedBox(
                            height: width * 0.5,
                            child: Image.asset(
                              'images/card-img-${(e % 3) + 1}.png',
                              alignment: Alignment.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  builder: (context, child) {
                    double theta = lerpDouble(0 + pi + pi / 2,
                        2 * pi + pi + pi / 2, (page.value - e) / (rows))!;
                    double x = (radius - containerWidth / 2) * cos(theta);
                    double y = (radius - containerWidth / 2) * sin(theta);
                    return Positioned(
                        left: width / 2 - (containerWidth * 2) / 2,
                        top: radius + height / 2 - containerWidth / 2,
                        width: containerWidth * 2,
                        height: containerWidth * 2,
                        child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..translate(
                                  x,
                                  lerpDouble(y - 40 * fem, y,
                                      (page.value - e).abs().clamp(0.0, 1.0))!)
                              ..rotateZ(theta),
                            child: child));
                  });
            }),
          ],
        ),
      ),
    ));
  }
}
