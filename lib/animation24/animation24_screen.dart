import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation24/widgets/custom_clipper.dart';
import 'package:flutter_me_animations/animation24/widgets/header_widget.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class Animation24Screen extends StatefulWidget {
  const Animation24Screen({super.key});

  @override
  State<Animation24Screen> createState() => _Animation24ScreenState();
}

class _Animation24ScreenState extends State<Animation24Screen> {
  final PageController pageController = PageController(viewportFraction: 0.8);

  final ValueNotifier<double> page = ValueNotifier(0.0);

  pagelistener() {
    page.value = pageController.page!;
  }

  @override
  void initState() {
    super.initState();
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
    final double gap = 10 * fem;
    final double containerWidth = width * 0.8;
    return Scaffold(
      backgroundColor: Colors.indigo.shade300,
      body: Stack(children: [
        AnimatedBuilder(
          animation: page,
          builder: (context, child) {
            return Transform.translate(
                offset: Offset(
                    lerpDouble(containerWidth - width, 0.0,
                        (1 - page.value.clamp(0.0, 1.0)))!,
                    0.0),
                child: child);
          },
          child: Container(
            width: width,
            height: height,
            color: Colors.white,
          ),
        ),
        Container(
            height: height,
            width: containerWidth,
            padding: EdgeInsets.all(3 * gap),
            child: const HeaderWidget(
              color: Colors.black,
            )),
        SizedBox(
          height: height,
          width: containerWidth,
          child: AnimatedBuilder(
            animation: page,
            builder: (context, child) {
              return ClipPath(
                  clipper:
                      MyCustomClipper(value: 1 - page.value.clamp(0.0, 1.0)),
                  child: child);
            },
            child: Container(
                color: Colors.indigo.shade900,
                padding: EdgeInsets.all(3 * gap),
                child: const HeaderWidget(
                  color: Colors.white,
                )),
          ),
        ),
        Positioned.fill(
            child: ListView(
          controller: pageController,
          physics: const PageScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: [
            ...List.generate(5, (index) => index).asMap().entries.map((e) {
              if (e.key == 4) {
                return SizedBox(
                  width: width - containerWidth,
                );
              }
              return SizedBox(
                width: containerWidth,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedBuilder(
                      animation: page,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset.lerp(
                              Offset(0.0, 20 * fem),
                              Offset(0.0, 120 * fem),
                              (page.value - e.key).abs().clamp(0.0, 1.0))!,
                          child: SizedBox(
                            width: containerWidth - 4 * gap,
                            child: child,
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          'images/movie${e.key + 1}.jpg',
                          height: height * 0.7,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    )),
              );
            })
          ],
        ))
      ]),
    );
  }
}
