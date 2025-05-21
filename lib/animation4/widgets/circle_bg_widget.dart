import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/models/slide.dart';

class CircleBgWidget extends StatelessWidget {
  final ValueNotifier<double> page;
  final Slide slide;

  const CircleBgWidget({super.key, required this.page, required this.slide});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final width = size.width;
    return RepaintBoundary(
      child: Align(
        alignment: Alignment.topCenter,
        child: AnimatedBuilder(
          animation: page,
          builder: (context, child) {
            final percent = (page.value - slide.index);
            return Opacity(
              opacity: Tween(begin: 1.0, end: 0.0)
                  .transform(((percent * 2.0).abs().clamp(0.0, 1.0))),
              child: Transform.scale(
                  scale: lerpDouble(1.0, 0.0, percent.abs().clamp(0.0, 1.0)),
                  child: child),
            );
          },
          child: Hero(
            tag: 'circle-${slide.index}',
            child: Container(
              width: width * 0.5,
              height: width * 0.5,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: slide.color.withValues(alpha: 0.2)),
            ),
          ),
        ),
      ),
    );
  }
}
