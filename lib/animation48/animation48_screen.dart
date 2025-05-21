import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class Animation48Screen extends StatefulWidget {
  const Animation48Screen({super.key});

  @override
  State<Animation48Screen> createState() => _Animation48ScreenState();
}

class _Animation48ScreenState extends State<Animation48Screen>
    with SingleTickerProviderStateMixin {
  final List<Color> paletteColors = [
    Colors.pink,
    Colors.teal,
    Colors.amber,
    Colors.purple,
    Colors.indigo,
  ];

  final List<int> palettes = List.generate(5, (index) => index);

  final List<int> inpalettes = List.generate(3, (index) => index);

  final ValueNotifier<double> angle = ValueNotifier(0.0);

  final ValueNotifier<double> angleStart = ValueNotifier(0.0);

  final ValueNotifier<double> angleEnd = ValueNotifier(0.0);

  Offset delta = Offset.zero;

  late AnimationController animationController;

  final ValueNotifier<Color> currentColor = ValueNotifier(Colors.black);

  @override
  void initState() {
    super.initState();
    animationController = AnimationController.unbounded(vsync: this);
  }

  @override
  void dispose() {
    angle.dispose();
    angleStart.dispose();
    angleEnd.dispose();
    currentColor.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final height = size.height;
    final fem = size.width / AppUtils.baseWidth;
    final containerSize = Size(80 * fem, 80 * fem);
    final gap = containerSize.height;
    final origin = Offset((gap + gap * 0.5 - 10), height - (gap - 10));
    return Scaffold(
      body: GestureDetector(
        onPanStart: (details) {
          final translate = details.localPosition;

          double currentangle =
              atan2(translate.dy - origin.dy, translate.dx - origin.dx);

          angleStart.value = (pi / 2 + currentangle);

          angleEnd.value = animationController.value;
        },
        onPanUpdate: (details) {
          final translate = details.localPosition;

          double currentangle =
              atan2(translate.dy - origin.dy, translate.dx - origin.dx);

          angle.value =
              (pi / 2 + currentangle + (angleEnd.value - angleStart.value))
                  .clamp(-pi / 4, pi);

          animationController.value = angle.value;
        },
        onPanEnd: (details) {
          if (animationController.value > pi / 4) {
            SpringSimulation springSimulation = SpringSimulation(
                const SpringDescription(mass: 1, stiffness: 100, damping: 5),
                animationController.value,
                pi / 2,
                0.01);

            animationController.animateWith(springSimulation);
          } else {
            SpringSimulation springSimulation = SpringSimulation(
                const SpringDescription(mass: 1, stiffness: 100, damping: 5),
                animationController.value,
                0.0,
                0.01);
            animationController.animateWith(springSimulation);
          }
        },
        child: Stack(
          children: [
            Positioned.fill(
                child: AnimatedBuilder(
                    animation: currentColor,
                    builder: (context, child) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.ease,
                        color: currentColor.value,
                      );
                    })),
            ...palettes.map((e) => Positioned(
                  bottom: gap,
                  left: gap,
                  width: containerSize.width,
                  child: AnimatedBuilder(
                    animation: animationController,
                    builder: (context, child) {
                      return Transform.rotate(
                        alignment: Alignment.bottomCenter,
                        angle: (animationController.value) *
                            (e / (palettes.length - 1)),
                        child: child,
                      );
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...inpalettes.map((i) => GestureDetector(
                                onTap: () {
                                  currentColor.value = paletteColors[e]
                                      .withBlue(
                                          ((i / (paletteColors.length - 1)) *
                                                  255)
                                              .toInt());
                                },
                                child: Container(
                                  height: containerSize.height,
                                  decoration: BoxDecoration(
                                      color: paletteColors[e].withBlue(
                                          ((i / (paletteColors.length - 1)) *
                                                  255)
                                              .toInt()),
                                      borderRadius: BorderRadius.circular(10)),
                                  margin: EdgeInsets.only(
                                      left: 5,
                                      right: 5,
                                      top: 5,
                                      bottom:
                                          i == inpalettes.length - 1 ? 5 : 0),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                )),
            Positioned(
              bottom: gap - 10,
              left: gap + gap * 0.5 - 10,
              width: 20,
              height: 20,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: Align(
                  child: AnimatedBuilder(
                      animation: currentColor,
                      builder: (context, child) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.ease,
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: currentColor.value,
                              shape: BoxShape.circle),
                        );
                      }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
