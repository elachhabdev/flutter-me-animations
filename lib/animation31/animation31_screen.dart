import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_me_animations/animation31/widgets/slider_ballon_widget.dart';
import 'package:flutter_me_animations/animation31/widgets/slider_bar_widget.dart';
import 'package:flutter_me_animations/animation31/widgets/slider_button_widget.dart';

class Animation31Screen extends StatefulWidget {
  const Animation31Screen({super.key});

  @override
  State<Animation31Screen> createState() => _Animation31ScreenState();
}

class _Animation31ScreenState extends State<Animation31Screen>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  bool isexpanded = false;

  double leadingX = 0;

  double followingX = 0;

  double prevFollowinX = 0;

  double angle = 0.0;

  Ticker? ticker;

  double decayFactor = 8.0;

  final double radius = 30;

  final double margin = 30;

  updateExpanded(status) {
    if (status == AnimationStatus.completed) {
      isexpanded = true;
    } else {
      isexpanded = false;
    }
  }

  Duration lastTick = Duration.zero;

  DateTime? lastMouvementTime;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this);
    animationController.addStatusListener(updateExpanded);

    ticker = createTicker((elapsed) {
      setState(() {
        prevFollowinX = followingX;

        final Duration deltaTime = elapsed - lastTick;

        final deltaTimeMS = deltaTime.inMilliseconds / 1000;

        lastTick = elapsed;

        followingX = lerpDouble(
            followingX, leadingX, 1 - exp(-decayFactor * deltaTimeMS))!;

        angle = lerpDouble(angle, -atan2(followingX - prevFollowinX, 5.0),
            1 - exp(-decayFactor * 0.5 * deltaTimeMS))!;

        if (lastMouvementTime != null) {
          final now = DateTime.now();
          if (now.difference(lastMouvementTime!) > const Duration(seconds: 2)) {
            lastMouvementTime = null;
            lastTick = Duration.zero;
            ticker!.stop();
          }
        }
      });
    });
  }

  double decay(double currentX, double targetX, double t, double decayFactor) {
    if (decayFactor <= 0) {
      throw ArgumentError('Decay factor must be greater than 0');
    }

    double distance = targetX - currentX;

    return currentX + (distance / decayFactor) * (1 - exp(-decayFactor * t));
  }

  startFollowing() {
    if (!ticker!.isActive) {
      ticker!.start();
    }
  }

  @override
  void dispose() {
    ticker?.dispose();
    ticker = null;
    lastMouvementTime = null;
    animationController.removeStatusListener(updateExpanded);
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            CustomPaint(
              painter: SliderBar(value: (leadingX / (width - margin))),
              size: Size(width - margin, height * 0.1),
            ),
            AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..translate(followingX)
                      ..rotateZ(angle)
                      ..scale(lerpDouble(0.0, 1.0, animationController.value)),
                    child: CustomPaint(
                      painter: SliderBallon(
                          x: (followingX / (width - margin - radius)),
                          value: animationController.value),
                      size: Size(radius, height * 0.1),
                    ),
                  );
                }),
            AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(leadingX, 0.0),
                    child: GestureDetector(
                      onPanStart: (details) {
                        lastMouvementTime = DateTime.now();

                        startFollowing();

                        if (isexpanded) {
                          return;
                        }

                        animationController.fling(
                            velocity: 0.01,
                            springDescription:
                                SpringDescription.withDampingRatio(
                              mass: 1.0,
                              stiffness: 1000.0,
                              ratio: 3.0,
                            ));
                      },
                      onPanUpdate: (details) {
                        lastMouvementTime = DateTime.now();

                        if (!isexpanded) {
                          return;
                        }

                        setState(() {
                          leadingX = (leadingX + details.delta.dx)
                              .clamp(0.0, width - margin - radius);
                        });
                      },
                      onPanEnd: (details) {
                        angle = 0.0;
                        lastMouvementTime = DateTime.now();

                        animationController.fling(
                            velocity: -0.01,
                            springDescription:
                                SpringDescription.withDampingRatio(
                              mass: 1.0,
                              stiffness: 1000.0,
                              ratio: 3.0,
                            ));
                      },
                      child: CustomPaint(
                        painter: SliderButton(value: animationController.value),
                        size: Size(radius, height * 0.1),
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
