import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class ItemsWidget extends StatelessWidget {
  final AnimationController animationController;
  final PageController pageController;
  final ValueNotifier<double> page;

  final List slides = [
    null,
    {'color': Colors.indigo},
    {'color': Colors.purple},
    {'color': Colors.blue.shade700}
  ];

  final List<String> titles = ['', 'Movie 1', 'Movie 2', 'Movie 3'];

  ItemsWidget({
    super.key,
    required this.animationController,
    required this.pageController,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double height = size.height;
    final double heightImage = size.height * 3 / 4;
    final double fem = size.width / AppUtils.baseWidth;
    final double gapImage = 30 * fem;

    return Positioned.fill(
        top: height - heightImage,
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Transform.translate(
                offset: Offset(0.0,
                    lerpDouble(0, heightImage, animationController.value)!),
                child: child);
          },
          child: RepaintBoundary(
            child: PageView.builder(
                controller: pageController,
                physics: const ClampingScrollPhysics(),
                itemCount: slides.length,
                itemBuilder: (context, index) {
                  if (slides[index] == null) {
                    return const SizedBox.shrink();
                  }
                  return AnimatedBuilder(
                      animation: page,
                      builder: (context, child) {
                        final double pagePercent =
                            (page.value - index).abs().clamp(0.0, 1.0);

                        return Opacity(
                          opacity: (1 -
                              (page.value < 0.25
                                  ? (((page.value / 0.25) - index))
                                      .abs()
                                      .clamp(0.0, 1.0)
                                  : 0.0)),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 5 * fem),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10 * fem, vertical: gapImage),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'images/movie${index + 1}.jpg',
                                  fit: BoxFit.cover,
                                  color: Color.lerp(
                                      Colors.white.withValues(alpha: 0.25),
                                      Colors.transparent,
                                      pagePercent),
                                  colorBlendMode: BlendMode.lighten,
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                }),
          ),
        ));
  }
}
