import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_me_animations/animation15/widgets/animated_curved_widget.dart';

class Animation15Screen extends StatefulWidget {
  const Animation15Screen({super.key});

  @override
  State<Animation15Screen> createState() => _Animation15ScreenState();
}

class _Animation15ScreenState extends State<Animation15Screen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  late double height;

  double x = 0.0;
  double y = 0.0;
  double position = 0.0;
  double prevposition = 0.0;

  bool initial = true;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController.unbounded(vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Size size = MediaQuery.of(context).size;

    height = size.height;
    prevposition = animationController.value = height * 0.5;
    y = height * 0.5;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return GestureDetector(
              onVerticalDragUpdate: (details) {
                y = (y + details.delta.dy).clamp(height * 0.1, height * 0.9);
                x = details.localPosition.dx;
                animationController.value = y;
                position = y;
              },
              onVerticalDragEnd: (details) {
                animationController.animateWith(SpringSimulation(
                    const SpringDescription(
                        mass: 1, damping: 4, stiffness: 100),
                    prevposition,
                    position,
                    details.velocity.pixelsPerSecond.dy));

                prevposition = position;
              },
              child: AnimatedCurvedPaint(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 700),
                x: x,
                y: animationController.value,
                position: prevposition,
              ),
            );
          }),
    );
  }
}
