import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class FirstItemWidget extends StatelessWidget {
  final AnimationController animationController;
  final ValueNotifier<double> page;
  const FirstItemWidget(
      {super.key, required this.animationController, required this.page});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;
    final double heightImage = size.height * 3 / 4;
    final double fem = size.width / AppUtils.baseWidth;
    final double gapImage = 30 * fem;

    return Positioned(
      top: height - heightImage + 2 * gapImage,
      left: gapImage,
      child: Align(
          alignment: Alignment.center,
          child: AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Transform.translate(
                  offset: Offset(0.0,
                      lerpDouble(0, heightImage, animationController.value)!),
                  child: child);
            },
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: page,
                builder: (context, child) {
                  final double pagePercent =
                      (page.value - 1).abs().clamp(0.0, 1.0);
                  final dy = height - heightImage + 2 * gapImage + gapImage;
                  return Transform.translate(
                    offset: Offset(
                        page.value < 1.0
                            ? lerpDouble(0.0, -gapImage, pagePercent)!
                            : lerpDouble(width * 0.8, 0.0, page.value)!,
                        lerpDouble(
                            0.0, -dy, page.value < 1.0 ? pagePercent : 0.0)!),
                    child: Container(
                        height: lerpDouble(
                            heightImage - 4 * gapImage,
                            height + 2 * gapImage,
                            page.value < 1.0 ? pagePercent : 0.0),
                        width: lerpDouble(width * 0.75, width,
                            page.value < 1.0 ? pagePercent : 0.0),
                        decoration: BoxDecoration(
                            color: Colors.indigo.shade900,
                            borderRadius: BorderRadius.circular(20)),
                        child: child),
                  );
                },
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.05),
                    radius: 40,
                    child: const Icon(
                      Icons.api_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
