import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation16/widgets/content_widget.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class Animation16Screen extends StatefulWidget {
  const Animation16Screen({super.key});

  @override
  State<Animation16Screen> createState() => _Animation16ScreenState();
}

class _Animation16ScreenState extends State<Animation16Screen> {
  final List slides = [
    'Pulp Fiction',
    'Good Fellas',
    'The Irishman',
    'Shutter Island',
    'Harry Potter',
    'Harry Potter',
    'Shutter Island',
    'Harry Potter',
    'Harry Potter'
  ];

  late PageController pageController;

  final ValueNotifier<double> page = ValueNotifier(0.0);

  pagelistener() {
    page.value = pageController.page!;
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    pageController.addListener(pagelistener);
  }

  @override
  void dispose() {
    pageController.removeListener(pagelistener);
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;
    final double fem = width / AppUtils.baseWidth;
    final double gap = 60.0 * fem;
    final double containerWidth = width * 0.6;
    final double containerHeight = width * 0.8;
    final double imageWidth = width * 0.5;
    final double topContainer = height * 0.2;
    final double topImage = height * 0.05;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: height * 0.2,
            height: containerHeight,
            left: gap,
            width: containerWidth,
            child: AnimatedBuilder(
                animation: page,
                builder: (context, child) {
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(lerpDouble(
                          0,
                          pi,
                          (page.value - page.value.floor())
                              .abs()
                              .clamp(0.0, 1.0))!),
                    child: child,
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(15 * fem),
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(25)),
                )),
          ),
          Positioned(
            top: topContainer,
            height: containerHeight,
            left: gap,
            width: containerWidth,
            child: AnimatedBuilder(
              animation: page,
              builder: (context, child) {
                final double pagePercent = page.value - page.value.floor();

                return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(lerpDouble(-2 * pi, 2 * pi,
                          0.5 * (pagePercent).abs().clamp(0.0, 1.0))!),
                    child: child);
              },
              child: ContentWidget(
                  page: page,
                  contentHeight: (topContainer - topImage),
                  fem: fem),
            ),
          ),
          Positioned.fill(
            top: topImage,
            child: PageView.builder(
              controller: pageController,
              itemBuilder: (context, index) => Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: imageWidth,
                  height: containerHeight,
                  margin: EdgeInsets.symmetric(
                      horizontal: gap + (containerWidth - imageWidth) / 2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset(
                      'images/movie${index + 1}.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              itemCount: 5,
            ),
          ),
        ],
      ),
    );
  }
}
