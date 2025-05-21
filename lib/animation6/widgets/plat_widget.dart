import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation6/widgets/three_arc.dart';

class PlatWidget extends StatelessWidget {
  final ValueNotifier<double> page;
  final ValueNotifier<int> currentindex;
  final List<Map<String, dynamic>> plats;
  final List<ImageProvider> imageProviders;

  const PlatWidget(
      {super.key,
      required this.page,
      required this.currentindex,
      required this.plats,
      required this.imageProviders});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final width = size.width;
    final containerImage = width * 0.7;

    return Align(
      alignment: Alignment.centerRight,
      child: RepaintBoundary(
        child: Hero(
          tag: 'plat',
          flightShuttleBuilder: (flightContext, animation, flightDirection,
              fromHeroContext, toHeroContext) {
            return AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Transform(
                    origin: Offset(containerImage * 0.5, 0.0),
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..translate(lerpDouble(
                          0.0, -containerImage * 0.5, animation.value))
                      ..rotateZ((2 * pi - pi / 2) * animation.value)
                      ..scale(lerpDouble(1.0, 1.1, animation.value)),
                    child: child);
              },
              child: RepaintBoundary(
                child: flightDirection == HeroFlightDirection.push
                    ? fromHeroContext.widget
                    : toHeroContext.widget,
              ),
            );
          },
          child: AnimatedBuilder(
            animation: page,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..translate(containerImage * 0.5)
                  ..rotateZ(lerpDouble(
                      0.0, 2 * pi, (page.value - page.value.floor()))!),
                child: child,
              );
            },
            child: ValueListenableBuilder(
                valueListenable: currentindex,
                builder: (context, currentindex, child) {
                  return CustomPaint(
                      size: Size(containerImage + 50, containerImage + 50),
                      painter: ThreeArc(
                          containerImage: containerImage,
                          color: plats[currentindex]['color']),
                      child: Image(
                        image: imageProviders[currentindex],
                        alignment: Alignment.center,
                        height: containerImage,
                        width: containerImage,
                      ));
                }),
          ),
        ),
      ),
    );
  }
}
