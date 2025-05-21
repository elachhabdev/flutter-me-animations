import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class Animation29Screen extends StatefulWidget {
  const Animation29Screen({super.key});

  @override
  State<Animation29Screen> createState() => _Animation29ScreenState();
}

class _Animation29ScreenState extends State<Animation29Screen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  //must be square
  final int rows = 3;
  final int cols = 3;

  Offset startPos = Offset.zero;
  Offset endPos = Offset.zero;
  Offset direction = Offset.zero;
  Offset prevdirection = Offset.zero;

  final ValueNotifier<int> currentindex = ValueNotifier(0);

  List<int> grids = List.generate(9, (index) => index);

  List<String> slides =
      List.generate(9, (index) => 'movie${Random().nextInt(6) + 1}.jpg');

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    currentindex.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;
    final double fem = width / AppUtils.baseWidth;
    final double gap = 10 * fem;
    final double containerHeight = height * 0.7;
    final double containerWidth = width * 0.7;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: OverflowBox(
          maxHeight: (containerHeight + 2 * gap) * rows,
          maxWidth: (containerWidth + 2 * gap) * cols,
          alignment: Alignment.topLeft,
          child: AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                    lerpDouble(prevdirection.dx, direction.dx,
                                animationController.value)! *
                            (containerWidth + 2 * gap) +
                        gap,
                    lerpDouble(prevdirection.dy, direction.dy,
                                animationController.value)! *
                            (containerHeight + 2 * gap) +
                        gap),
                child: GestureDetector(
                    onPanStart: (details) {
                      startPos = endPos = details.localPosition;
                    },
                    onPanUpdate: (details) {
                      endPos = details.localPosition;
                    },
                    onPanEnd: (details) {
                      Offset moveDelta = endPos - startPos;

                      final distance = moveDelta.distance;

                      if (distance > 30 * fem) {
                        moveDelta /= distance;
                        Offset dir = Offset(
                          moveDelta.dx.roundToDouble(),
                          moveDelta.dy.roundToDouble(),
                        );

                        prevdirection = animationController.isAnimating
                            ? Offset(
                                lerpDouble(prevdirection.dx, direction.dx,
                                    animationController.value)!,
                                lerpDouble(prevdirection.dy, direction.dy,
                                    animationController.value)!)
                            : direction;

                        direction += dir;

                        final Offset directionclamped = Offset(
                            direction.dx.clamp(-(cols - 1.0), 0),
                            direction.dy.clamp(-(rows - 1.0), 0));

                        direction = directionclamped;

                        currentindex.value = rows * direction.dy.abs().toInt() +
                            direction.dx.abs().toInt();

                        animationController.reset();
                        animationController.fling(
                            velocity: 0.01,
                            springDescription:
                                SpringDescription.withDampingRatio(
                                    mass: 1, stiffness: 1000, ratio: 2.0));
                      }
                      startPos = endPos = Offset.zero;
                    },
                    child: child),
              );
            },
            child: Column(
              children: [
                ...grids.slices(cols).map((row) {
                  return Row(children: [
                    ...row.map((col) {
                      return Container(
                        height: containerHeight,
                        width: containerWidth,
                        margin: EdgeInsets.all(gap),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                'images/${slides[col]}',
                                fit: BoxFit.cover,
                              ),
                              AnimatedBuilder(
                                  animation: currentindex,
                                  builder: (context, child) {
                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.ease,
                                      color: Colors.black.withValues(
                                          alpha: currentindex.value == col
                                              ? 0.0
                                              : 0.7),
                                    );
                                  })
                            ],
                          ),
                        ),
                      );
                    })
                  ]);
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
