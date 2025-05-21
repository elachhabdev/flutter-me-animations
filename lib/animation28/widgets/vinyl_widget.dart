import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class VinylWidget extends StatelessWidget {
  final AnimationController animationController;
  final AnimationController animationController2;
  final ValueNotifier<double> translateX;
  final int totalSecondSong;

  const VinylWidget(
      {super.key,
      required this.animationController,
      required this.animationController2,
      required this.totalSecondSong,
      required this.translateX});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..scale(lerpDouble(1.0, 1.4, animationController.value))
            ..rotateX(lerpDouble(0.0, -pi / 5, animationController.value)!),
          child: AnimatedBuilder(
              animation: translateX,
              builder: (context, _) {
                return Transform.rotate(
                    angle: lerpDouble(0.0, 2 * pi, translateX.value)!,
                    child: child);
              }),
        );
      },
      child: AnimatedBuilder(
        animation: animationController2,
        builder: (context, child) {
          return Transform.rotate(
              alignment: Alignment.center,
              angle: lerpDouble(0, 2 * pi,
                  (animationController2.value * (totalSecondSong * 0.4)))!,
              child: child);
        },
        child: Align(
            alignment: Alignment.center,
            child: Image.asset(
              'images/vinyl.png',
              width: width * 0.8,
            )),
      ),
    );
  }
}
