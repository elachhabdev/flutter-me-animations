import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class FabWidget extends StatefulWidget {
  final int index;

  const FabWidget({super.key, required this.index});

  @override
  State<FabWidget> createState() => FabWidgetState();
}

class FabWidgetState extends State<FabWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  bool isexpanded = false;

  void toggle() {
    _animationController.stop();
    _animationController.animateWith(SpringSimulation(
        const SpringDescription(mass: 1, stiffness: 100, damping: 8),
        isexpanded ? 1 : 0,
        isexpanded ? 0 : 1,
        0.01));
    isexpanded = !isexpanded;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController.unbounded(vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  final List<Color> slides = [
    Colors.indigo.shade800,
    Colors.purple.shade800,
    Colors.red.shade800,
    Colors.blue.shade800,
    Colors.blueGrey.shade800
  ];

  final List<IconData> icons = [
    Icons.access_time_filled_rounded,
    Icons.account_circle_rounded,
    Icons.add_circle_sharp,
    Icons.admin_panel_settings,
    Icons.wifi_tethering_outlined
  ];

  final double raduis = 80;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final costheta = cos(((widget.index - slides.length - 1) * pi) / 3);
        final sintheta = sin(((widget.index - slides.length - 1) * pi) / 3);
        return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..translate((_animationController.value * raduis) * costheta,
                  (_animationController.value * raduis) * sintheta),
            child: child);
      },
      child: CircleAvatar(
        radius: 25,
        backgroundColor: slides[widget.index],
        child: Icon(
          icons[widget.index],
          color: Colors.white,
        ),
      ),
    );
  }
}
