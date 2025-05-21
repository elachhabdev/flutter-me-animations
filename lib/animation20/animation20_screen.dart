import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_me_animations/animation20/widgets/card_widget.dart';
import 'package:flutter_me_animations/animation20/widgets/header_widget.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class Animation20Screen extends StatefulWidget {
  const Animation20Screen({super.key});

  @override
  State<Animation20Screen> createState() => _Animation20ScreenState();
}

class _Animation20ScreenState extends State<Animation20Screen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  final ValueNotifier<double> translateY = ValueNotifier(0.0);

  final ValueNotifier<double> page = ValueNotifier(0.0);

  final List slides = List.generate(4, (index) => index);

  Offset startpos = const Offset(0.0, 0.0);

  Offset endpos = const Offset(0.0, 0.0);

  late double height;

  late double width;

  late double fem;

  late double containerHeight;

  late double gap;

  decay() {
    translateY.value = animationController.value
        .clamp(-(containerHeight + gap) * (slides.length - 1), 0.0);

    page.value = (translateY.value / (containerHeight + gap)).abs();
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
    containerHeight = height * 0.5;
    fem = width / AppUtils.baseWidth;
    gap = 25 * fem;
  }

  @override
  void dispose() {
    page.dispose();
    translateY.dispose();
    animationController.removeListener(decay);
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple.shade800,
        body: Column(children: [
          const HeaderWidget(),
          Expanded(
              child: GestureDetector(
            onPanStart: (details) {
              if (animationController.isAnimating) {
                animationController.stop();
              }
              startpos = endpos = details.localPosition;
            },
            onPanUpdate: (details) {
              translateY.value = (translateY.value - details.delta.dy)
                  .clamp(-(containerHeight + gap) * (slides.length - 1), 0.0);

              page.value = (translateY.value / (containerHeight + gap)).abs();
              endpos = details.localPosition;
            },
            onPanEnd: (details) {
              /*  
             decay
             like animation1
             final velocity = details.velocity.pixelsPerSecond;
             
             */

              //fling

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

              final itemHeight = (containerHeight + gap);

              final velocity = Offset(
                  0.0, dir.dy < 0.0 ? itemHeight * 0.7 : itemHeight * 0.1);

              final frictionSimulation =
                  FrictionSimulation(0.4, translateY.value, velocity.dy);

              final snapedContainer = frictionSimulation.finalX / (itemHeight);

              double snap = snapedContainer.floor() * (itemHeight);

              final springsimulation = ScrollSpringSimulation(
                  SpringDescription.withDampingRatio(
                    mass: 1.0,
                    stiffness: 1000.0,
                    ratio: 2.0,
                  ),
                  translateY.value,
                  snap,
                  0.1);

              animationController.animateWith(springsimulation);
            },
            child: Stack(fit: StackFit.expand, children: [
              ...slides.reversed.map((e) => AnimatedBuilder(
                    animation: page,
                    builder: (context, child) {
                      final double pagePercent = (page.value - e);
                      return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..translate(
                                0.0,
                                page.value >= e
                                    ? containerHeight *
                                        pagePercent.abs().clamp(0.0, 1.0)
                                    : 25.0 * fem * pagePercent)
                            ..scale(
                                1 - lerpDouble(0.0, 0.07, pagePercent.abs())!),
                          child: child);
                    },
                    child: CardWidget(
                        containerHeight: containerHeight,
                        gap: gap,
                        page: page,
                        index: e),
                  ))
            ]),
          ))
        ]));
  }
}
