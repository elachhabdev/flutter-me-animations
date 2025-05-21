import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_me_animations/animation38/widgets/card_widget.dart';

class Animation38Screen extends StatefulWidget {
  const Animation38Screen({super.key});

  @override
  State<Animation38Screen> createState() => _Animation38ScreenState();
}

class _Animation38ScreenState extends State<Animation38Screen>
    with SingleTickerProviderStateMixin {
  final List<int> items = List.generate(30, (index) => index);

  final List<String> datatimes = List.generate(
      30,
      (index) =>
          '2024-02-${(index % 30 + 1) < 10 ? '0${(index % 30 + 1)}' : (index % 30 + 1)}');

  final List<Color> colors = List.generate(
      30, (index) => Colors.teal.withBlue(((index / 30) * 255).toInt()));

  final double containerheight = 100;

  final ValueNotifier<double> translateY = ValueNotifier(0.0);

  final ValueNotifier<double> page = ValueNotifier(0.0);

  Offset startpos = Offset.zero;

  Offset endpos = Offset.zero;

  late AnimationController animationController;

  decay() {
    translateY.value = animationController.value
        .clamp(-(items.length - 1) * containerheight, 0.0);
    page.value = (translateY.value / (containerheight));
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController.unbounded(vsync: this);
    animationController.addListener(decay);
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
      backgroundColor: Colors.black,
      body: GestureDetector(
        onPanStart: (details) {
          if (animationController.isAnimating) {
            animationController.stop();
          }
          startpos = endpos = details.localPosition;
        },
        onPanUpdate: (details) {
          translateY.value = (translateY.value - details.delta.dy)
              .clamp(-(items.length - 1) * containerheight, 0.0);
          page.value = (translateY.value / (containerheight));

          endpos = details.localPosition;
        },
        onPanEnd: (details) {
          final velocity = details.velocity.pixelsPerSecond;

          final frictionSimulation =
              FrictionSimulation(0.4, translateY.value, -velocity.dy * 0.08);

          Offset moveDelta = endpos - startpos;

          final distance = moveDelta.distance;

          if (distance == 0) {
            return;
          }

          moveDelta /= distance;

          final dir = Offset(
            moveDelta.dx.roundToDouble(),
            moveDelta.dy.roundToDouble(),
          );

          final snapedContainer =
              (frictionSimulation.finalX / (containerheight));

          double snap = dir.dy < 0.0
              ? (snapedContainer).round() * (containerheight)
              : (snapedContainer).floor() * (containerheight);

          final springsimulation = SpringSimulation(
              SpringDescription.withDampingRatio(
                mass: 1.0,
                stiffness: 1000.0,
                ratio: 2.0,
              ),
              translateY.value,
              snap,
              velocity.dy * 0.08);

          animationController.animateWith(springsimulation);
        },
        child: Stack(
          children: [
            ...items.map((index) {
              return Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedBuilder(
                      animation: page,
                      builder: (context, child) {
                        return Transform(
                            alignment: Alignment.bottomCenter,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..scale(lerpDouble(
                                  1.0,
                                  0.4,
                                  ((items.length - 1) - (index - page.value))
                                          .abs() /
                                      (items.length - 1)))
                              ..translate(
                                  0.0,
                                  ((items.length - 1) - (index - page.value)) <=
                                          0.0
                                      ? lerpDouble(
                                          0.0,
                                          containerheight + 50,
                                          ((index - page.value) -
                                                  (items.length - 1))
                                              .clamp(0.0, 1.0))!
                                      : lerpDouble(
                                          0.0,
                                          -containerheight * 0.5,
                                          ((items.length - 1) -
                                              (index - page.value)))!),
                            child: child);
                      },
                      child: CardWidget(
                        index: index,
                        page: page,
                        containerHeight: containerheight,
                        itemsCount: items.length,
                      )));
            }),
            Positioned.fill(
                child: RepaintBoundary(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: const [Colors.green, Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.center.add(const Alignment(0.0, 0.5))),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
