import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_me_animations/animation21/widgets/content_widget.dart';
import 'package:flutter_me_animations/animation21/widgets/oval_widget.dart';
import 'package:flutter_me_animations/animation21/widgets/text_widget.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class Animation21Screen extends StatefulWidget {
  const Animation21Screen({super.key});

  @override
  State<Animation21Screen> createState() => _Animation21ScreenState();
}

class _Animation21ScreenState extends State<Animation21Screen>
    with SingleTickerProviderStateMixin {
  final List<String> days = ['Mon', 'Thu', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  late double width;

  late double height;

  late double fem;

  late double gap;

  late double containerWidth;

  late double containerHeight;

  late double contentWidth;

  late double contentHeight;

  final ValueNotifier<double> page = ValueNotifier(0.0);

  final ValueNotifier<double> translateY = ValueNotifier(0.0);

  late AnimationController animationController;

  Offset startpos = const Offset(0.0, 0.0);

  Offset endpos = const Offset(0.0, 0.0);

  late double snapedHeight;

  late double radiusX;

  late double radiusY;

  double angle = pi;

  double currentAngle = pi;

  int selectedIndex = 0;

  decay() {
    translateY.value = animationController.value.clamp(
      -(snapedHeight) * (days.length - 1),
      0.0,
    );

    page.value = (translateY.value / (snapedHeight)).abs();
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

    width = size.width;

    height = size.height;

    fem = width / AppUtils.baseWidth;

    gap = 20 * fem;

    containerWidth = width * 0.6;

    containerHeight = width;

    contentWidth = 75 * fem;

    contentHeight = 30 * fem;

    radiusX = containerWidth * 0.5;

    radiusY = containerHeight * 0.5;

    /* final double thetap1 = pi + lerpDouble(0.0, 2 * pi, 0.0)!;

    final Offset p1 = Offset(0.0, radiusY * 0.5 * sin(thetap1));

    final double thetap2 = pi + lerpDouble(0.0, 2 * pi, 1 / (days.length))!;

    final Offset p2 = Offset(0.0, radiusY * 0.5 * sin(thetap2));

    snapedHeight = (p2 - p1).distance; */

    snapedHeight = radiusY * 0.5;
  }

  @override
  void dispose() {
    translateY.dispose();
    page.dispose();
    animationController.removeListener(decay);
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ContentWidget(containerHeight: containerHeight, page: page),
          Positioned(
            height: containerHeight,
            width: containerWidth + contentWidth * 0.5,
            top: height * 0.5 - radiusY,
            left: width - radiusX - contentWidth,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  left: contentWidth,
                  child: CustomPaint(painter: OvalShap()),
                ),
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: page,
                    builder: (context, child) {
                      final spaceEye = 14;
                      return Stack(
                        children: [
                          Positioned.fill(
                            left: contentWidth * 1.5 - spaceEye,
                            child: CustomPaint(
                              painter: CircleShape(angle: angle),
                            ),
                          ),
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ...days.asMap().entries.map((e) {
                                final double theta =
                                    pi +
                                    lerpDouble(
                                      0.0,
                                      2 * pi,
                                      (page.value - e.key) / days.length,
                                    )!;

                                final double x = (radiusX) * cos(theta);

                                final double y = (radiusY) * sin(theta);

                                return Positioned(
                                  top: y + radiusY - contentHeight * 0.5,
                                  left: x + radiusX + contentWidth * 0.5,
                                  width: contentWidth,
                                  height: contentHeight,
                                  child: Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()
                                      ..scale(
                                        lerpDouble(
                                          1.7,
                                          1.1,
                                          (page.value - e.key).abs().clamp(
                                            0.0,
                                            1.0,
                                          ),
                                        ),
                                      )
                                      ..rotateZ(theta - pi),
                                    child: GestureDetector(
                                      onPanStart: (details) {
                                        if (animationController.isAnimating) {
                                          animationController.stop();
                                        }
                                        startpos = endpos =
                                            details.localPosition;
                                        selectedIndex = e.key;
                                        angle =
                                            pi +
                                            lerpDouble(
                                              0.0,
                                              2 * pi,
                                              (page.value - selectedIndex) /
                                                  days.length,
                                            )!;
                                      },
                                      onPanUpdate: (details) {
                                        translateY.value =
                                            (translateY.value +
                                                    details.delta.dy)
                                                .clamp(
                                                  -(snapedHeight) *
                                                      (days.length - 1),
                                                  0.0,
                                                );

                                        page.value =
                                            (translateY.value / (snapedHeight))
                                                .abs();

                                        angle =
                                            pi +
                                            lerpDouble(
                                              0.0,
                                              2 * pi,
                                              (page.value - selectedIndex) /
                                                  days.length,
                                            )!;

                                        endpos = details.localPosition;
                                      },
                                      onPanEnd: (details) {
                                        Offset moveDelta = endpos - startpos;
                                        final distance = moveDelta.distance;

                                        if (distance == 0.0) {
                                          return;
                                        }

                                        moveDelta /= distance;

                                        final dir = Offset(
                                          moveDelta.dx.roundToDouble(),
                                          moveDelta.dy.roundToDouble(),
                                        );

                                        final velocity = Offset(
                                          0.0,
                                          dir.dy > 0.0
                                              ? snapedHeight * 0.6
                                              : snapedHeight * 0.4,
                                        );

                                        final frictionSimulation =
                                            FrictionSimulation(
                                              0.4,
                                              translateY.value,
                                              velocity.dy,
                                            );

                                        final double snapedContainer =
                                            (frictionSimulation.finalX /
                                            snapedHeight);

                                        double snap =
                                            snapedContainer.floor() *
                                            (snapedHeight);

                                        final springsimulation =
                                            ScrollSpringSimulation(
                                              SpringDescription.withDampingRatio(
                                                mass: 1.0,
                                                stiffness: 1000.0,
                                                ratio: 2.0,
                                              ),
                                              translateY.value,
                                              snap,
                                              0.1,
                                            );

                                        animationController.animateWith(
                                          springsimulation,
                                        );

                                        angle = pi;
                                      },
                                      child: TextWidget(
                                        contentHeight: contentHeight,
                                        contentWidth: contentWidth,
                                        pagePercent: (page.value - e.key),
                                        day: e.key + 1,
                                        dayTitle: e.value,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
