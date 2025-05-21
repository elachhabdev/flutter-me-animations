import 'dart:ui';

import 'package:flutter/material.dart';

class PosterWidget extends StatelessWidget {
  final double containerHeight;
  final double containerImage;
  final double gap;
  final ValueNotifier<double> page;
  final double fem;
  final int index;

  const PosterWidget(
      {super.key,
      required this.containerHeight,
      required this.containerImage,
      required this.fem,
      required this.gap,
      required this.index,
      required this.page});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: containerImage,
        width: containerImage,
        child: AnimatedBuilder(
            animation: page,
            builder: (context, child) {
              return Transform.scale(
                  scale: lerpDouble(
                      1.0, 0.8, (page.value - index).abs().clamp(0.0, 1.0)),
                  child: Stack(children: [
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.lerp(
                            Alignment.centerRight,
                            Alignment.centerLeft,
                            ((page.value - index) * 4).abs().clamp(0.0, 1.0))!,
                        child: Image.asset(
                          'images/vinyl.png',
                          fit: BoxFit.contain,
                          height: containerImage * 0.6,
                          width: containerImage * 0.6,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        'images/vynil${(index % 2) + 1}.jpg',
                        fit: BoxFit.cover,
                        height: containerImage * 0.6,
                        width: containerImage * 0.6,
                      ),
                    )
                  ]));
            }));
  }
}
