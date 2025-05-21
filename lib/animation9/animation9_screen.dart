import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation9/widgets/content_widget.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class Animation9Screen extends StatefulWidget {
  const Animation9Screen({super.key});

  @override
  State<Animation9Screen> createState() => _Animation9ScreenState();
}

class _Animation9ScreenState extends State<Animation9Screen> {
  final List<Map<String, Color>> slides = [
    {'color': Colors.green},
    {'color': Colors.indigo},
    {'color': Colors.blue.shade700},
    {'color': Colors.purple}
  ];

  late PageController pageController;

  final ValueNotifier<double> page = ValueNotifier(0.0);

  pagelistner() {
    page.value = pageController.page!;
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    pageController.addListener(pagelistner);
  }

  @override
  void dispose() {
    page.dispose();
    pageController.removeListener(pagelistner);
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final width = size.width;

    final height = size.height;

    final fem = width / AppUtils.baseWidth;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
              animation: page,
              builder: (context, child) {
                final int currentindex = page.value.floor();
                final int nextindex =
                    (currentindex + 1).clamp(0, slides.length - 1);
                return Positioned.fill(
                    child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Color.lerp(
                          slides[currentindex]['color'],
                          slides[nextindex]['color'],
                          (page.value - page.value.floor()))),
                ));
              }),
          Positioned(
              top: -height * 0.5,
              child: AnimatedBuilder(
                  animation: page,
                  builder: (context, child) {
                    final double pagePercent = page.value - page.value.floor();
                    return Transform.rotate(
                      angle: lerpDouble(
                          -pi / 16,
                          -pi,
                          (pagePercent < 0.5
                              ? pagePercent
                              : 1 - (pagePercent)))!,
                      alignment: Alignment.centerLeft,
                      child: child,
                    );
                  },
                  child: Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(55)),
                  ))),
          Positioned.fill(
              child: PageView.builder(
            itemCount: slides.length,
            controller: pageController,
            itemBuilder: (context, item) => const ContentWidget(),
          )),
          Positioned.fill(
              bottom: 40 * fem,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  ...slides.asMap().entries.map((e) {
                    return AnimatedBuilder(
                        animation: page,
                        builder: (context, child) {
                          final int index = e.key;
                          final double percent =
                              (page.value - index).abs().clamp(0.0, 1);

                          return Transform.scale(
                            scale: (1.2 - 0.2 * percent),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                  color: Color.lerp(
                                      Colors.white,
                                      Colors.white.withValues(alpha: 0.5),
                                      percent),
                                  shape: BoxShape.circle),
                              width: 15,
                              height: 15,
                            ),
                          );
                        });
                  })
                ]),
              ))
        ],
      ),
    );
  }
}
