import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation2/widgets/box_widget.dart';
import 'package:flutter_me_animations/animation2/widgets/content_widget.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class Item extends StatefulWidget {
  final int index;
  final PageController pageController;
  const Item({super.key, required this.index, required this.pageController});

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> with SingleTickerProviderStateMixin {
  final List<Color> slideColors = [
    const Color(0xFFD8C1D4),
    const Color(0xFFFFC0CF),
    const Color(0xFFFFC5B0)
  ];

  int get index => widget.index;

  final ValueNotifier<bool> isexpandedNotifier = ValueNotifier(false);

  late double width;
  late double height;
  late double fem;
  late double containerHeight;
  late double containerWidth;
  late double gap;

  PageController get pagecontroller => widget.pageController;

  late AnimationController animationController;
  late Animation<double> animation;
  late Animation<double> animationOpacity;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Size size = MediaQuery.of(context).size;

    width = size.width;
    height = size.height;
    fem = width / AppUtils.baseWidth;
    containerHeight = width * 0.8;
    containerWidth = width * 0.5;
    gap = 30 * fem;
  }

  isexpandedClose() {
    if (isexpandedNotifier.value) {
      isexpandedNotifier.value = false;
      animationController.reset();
    }
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));

    animation = Tween<double>(begin: 0.0, end: 0.5).animate(CurvedAnimation(
        parent: animationController, curve: const Interval(0.0, 0.5)));

    animationOpacity =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval(
              0.5,
              1.0,
            )));
    pagecontroller.addListener(isexpandedClose);
  }

  @override
  void dispose() {
    pagecontroller.removeListener(isexpandedClose);
    isexpandedNotifier.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleHeight = height - width * 0.5 - gap * 4 - gap * 0.5;
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedBuilder(
          animation: pagecontroller,
          builder: (context, child) {
            double page = pagecontroller.position.hasContentDimensions
                ? pagecontroller.page!
                : 0.0;

            final percent = (index - page).abs().clamp(0.0, 1.0);
            return Transform(
                alignment: Alignment.topCenter,
                transform: Matrix4.identity()
                  ..rotateZ(
                      lerpDouble(0.0, (index < page) ? 0.2 : -0.2, percent)!)
                  ..translate(lerpDouble(
                      0.0, (index < page) ? -width : width, percent)!),
                child: child);
          },
          child: Container(
            color: slideColors[index],
          ),
        ),
        RepaintBoundary(
          child: ContentWidget(
            index: index,
            pageController: pagecontroller,
            gap: gap,
          ),
        ),
        ValueListenableBuilder(
          valueListenable: isexpandedNotifier,
          builder: (context, isexpanded, child) {
            return AnimatedPositioned(
              duration: const Duration(milliseconds: 150),
              bottom: isexpanded ? 0 : 30 * fem,
              width: width,
              child: Align(
                alignment: Alignment.center,
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    alignment: Alignment.topCenter,
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(isexpanded ? 0.0 : 25.0),
                        color: Colors.grey.shade900),
                    width: isexpanded ? width : 50 * fem,
                    height: isexpanded ? visibleHeight : 50 * fem,
                    child: child),
              ),
            );
          },
          child: BoxWidget(
            animationOpacity: animationOpacity,
          ),
        ),
        Positioned(
            bottom: 30 * fem,
            width: width,
            child: Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  isexpandedNotifier.value = !isexpandedNotifier.value;

                  if (isexpandedNotifier.value) {
                    animationController.forward();
                  } else {
                    animationController.reset();
                  }
                },
                child: ValueListenableBuilder(
                    valueListenable: isexpandedNotifier,
                    builder: (context, isexpanded, child) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: isexpanded
                                ? Colors.white
                                : Colors.grey.shade900),
                        width: 50 * fem,
                        height: 50 * fem,
                        child: RotationTransition(
                          turns: animation,
                          child: Icon(
                            isexpanded ? Icons.close : Icons.shopping_basket,
                            color: isexpanded ? Colors.black87 : Colors.white,
                            size: 22,
                          ),
                        ),
                      );
                    }),
              ),
            ))
      ],
    );
  }
}
