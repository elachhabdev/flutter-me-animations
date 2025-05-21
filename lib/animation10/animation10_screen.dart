import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation10/widgets/first_item_widget.dart';
import 'package:flutter_me_animations/animation10/widgets/header_widget.dart';
import 'package:flutter_me_animations/animation10/widgets/items_widget.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class Animation10Screen extends StatefulWidget {
  const Animation10Screen({super.key});

  @override
  State<Animation10Screen> createState() => _Animation10ScreenState();
}

class _Animation10ScreenState extends State<Animation10Screen>
    with SingleTickerProviderStateMixin {
  late PageController pageController;

  late AnimationController animationController;

  final ValueNotifier<double> page = ValueNotifier(1.0);

  late double heightImage;

  late double gapImage;

  late double height;

  late double width;

  late double fem;

  pagelistener() {
    page.value = pageController.page!;
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 1, viewportFraction: 0.8);
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    pageController.addListener(pagelistener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final size = MediaQuery.of(context).size;

    height = size.height;
    width = size.width;
    fem = width / AppUtils.baseWidth;
    heightImage = size.height * 3 / 4;
    gapImage = 30 * fem;
  }

  @override
  void dispose() {
    page.dispose();
    animationController.dispose();
    pageController.removeListener(pagelistener);
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        Positioned(
            top: gapImage * 2,
            left: gapImage * 0.5,
            child: AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  return Transform.translate(
                      offset: Offset(
                          lerpDouble(
                              0.0, -gapImage * 0.5, animationController.value)!,
                          lerpDouble(
                              0.0, -gapImage * 3, animationController.value)!),
                      child: child);
                },
                child: HeaderWidget(
                  animationController: animationController,
                ))),
        FirstItemWidget(animationController: animationController, page: page),
        ItemsWidget(
            animationController: animationController,
            pageController: pageController,
            page: page)
      ]),
    );
  }
}
