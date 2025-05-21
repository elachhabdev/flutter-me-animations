import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation10/widgets/content_widget.dart';
import 'package:flutter_me_animations/animation10/widgets/title_widget.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class HeaderWidget extends StatelessWidget {
  final AnimationController animationController;

  const HeaderWidget({super.key, required this.animationController});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;
    final double fem = size.width / AppUtils.baseWidth;
    final double gapImage = 30 * fem;
    const double borderWidth = 2;

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        animationController.value += details.delta.dy / height;
      },
      onVerticalDragEnd: (details) {
        animationController.fling(
            velocity: details.velocity.pixelsPerSecond.dy / height,
            springDescription: SpringDescription.withDampingRatio(
              mass: 1.0,
              stiffness: 1000.0,
              ratio: 3.0,
            ));
      },
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Container(
              width: lerpDouble(
                  width - gapImage, width, animationController.value),
              height: lerpDouble(4 * gapImage, height + 4 * gapImage,
                  animationController.value),
              decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50,
                  borderRadius: BorderRadius.circular(20)),
              child: child);
        },
        child: Stack(
          children: [
            AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  return Positioned(
                      left: 20 * fem,
                      top: lerpDouble(
                          gapImage, gapImage * 4, animationController.value),
                      child: child!);
                },
                child: const TitleWidget()),
            AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return Positioned(
                  right: lerpDouble(40 * fem + borderWidth,
                      20 * fem + borderWidth, animationController.value),
                  top: lerpDouble(gapImage + borderWidth,
                      gapImage * 3 + borderWidth, animationController.value),
                  child: child!,
                );
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage('images/movie1.jpg'),
                radius: 25,
              ),
            ),
            AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return Positioned(
                  right: 20 * fem,
                  top: lerpDouble(
                      gapImage, gapImage * 3, animationController.value),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white, width: borderWidth)),
                    child: FadeTransition(
                      opacity: Tween(begin: 1.0, end: 0.0)
                          .animate(animationController),
                      child: child,
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 25,
                child: Icon(
                  Icons.call_to_action,
                  color: Colors.indigo.shade900,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return Positioned(
                  top: lerpDouble(height * 0.4, height * 0.4 + gapImage * 4,
                      animationController.value),
                  child: child!,
                );
              },
              child: const ContentWidget(),
            )
          ],
        ),
      ),
    );
  }
}
