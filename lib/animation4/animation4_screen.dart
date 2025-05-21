import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation4/widgets/circle_bg_widget.dart';
import 'package:flutter_me_animations/animation4/widgets/content_widget.dart';
import 'package:flutter_me_animations/animation4/widgets/title_widget.dart';

import 'dart:math';

import 'package:flutter_me_animations/models/slide.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class Animation4Screen extends StatefulWidget {
  const Animation4Screen({super.key});

  @override
  State<Animation4Screen> createState() => _Animation4ScreenState();
}

class _Animation4ScreenState extends State<Animation4Screen> {
  final List<Slide> slides = const [
    Slide(
        index: 0,
        title: 'Oculus Rift',
        image: 'image3.png',
        color: Colors.orange),
    Slide(
        index: 1,
        title: 'Oculus Quest',
        image: 'image3.png',
        color: Colors.indigo),
    Slide(
        index: 2,
        title: 'Shutter Pico',
        image: 'image3.png',
        color: Colors.purple),
    Slide(
        index: 3, title: 'Oculus VR', image: 'image3.png', color: Colors.blue),
  ];

  late PageController pageController;

  final ValueNotifier<double> page = ValueNotifier(0.0);

  pagestack() {
    page.value = pageController.page!;
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    pageController.addListener(pagestack);
  }

  @override
  void dispose() {
    page.dispose();
    pageController.removeListener(pagestack);
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final fem = width / AppUtils.baseWidth;

    return Scaffold(
      body: SafeArea(
        child: Stack(fit: StackFit.expand, children: [
          Positioned(
              left: 10 * fem,
              top: 20 * fem,
              height: 40 * fem,
              width: width * 0.5,
              child: ClipRect(
                clipBehavior: Clip.hardEdge,
                child: OverflowBox(
                  maxHeight: 40 * fem * slides.length,
                  alignment: Alignment.topCenter,
                  child: AnimatedBuilder(
                      animation: page,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0.0, -40 * fem * page.value),
                          child: child,
                        );
                      },
                      child: TitleWidget(slides: slides)),
                ),
              )),
          ...slides.map(
            (e) => Positioned.fill(
                top: height * 0.15,
                child: CircleBgWidget(page: page, slide: e)),
          ),
          Positioned.fill(
            top: height * 0.15,
            child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                controller: pageController,
                itemCount: slides.length,
                itemBuilder: (context, index) => ContentWidget(
                      index: index,
                      page: page,
                      slide: slides[index],
                      key: ValueKey(index),
                    )),
          ),
          Positioned(
              bottom: 60 * fem,
              left: -30 * fem,
              child: Transform.rotate(
                angle: -pi / 2,
                child: Text('OCULUS VR',
                    style: TextStyle(color: Colors.black, fontSize: 20 * fem)),
              )),
          Positioned(
              right: 20 * fem,
              bottom: 20 * fem,
              height: 30 * fem,
              child: RepaintBoundary(
                child: Stack(
                  children: [
                    Row(
                      children: [
                        ...slides.map((e) => SizedBox(
                              width: 30 * fem,
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 10 * fem,
                                  height: 10 * fem,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: e.color.withValues(alpha: 0.5)),
                                ),
                              ),
                            ))
                      ],
                    ),
                    AnimatedBuilder(
                      animation: page,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(page.value * 30 * fem, 0.0),
                          child: child,
                        );
                      },
                      child: Container(
                        width: 30 * fem,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black38,
                            ),
                            shape: BoxShape.circle),
                      ),
                    ),
                  ],
                ),
              ))
        ]),
      ),
    );
  }
}
