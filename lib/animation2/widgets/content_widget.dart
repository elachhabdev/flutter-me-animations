import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class ContentWidget extends StatelessWidget {
  final int index;
  final PageController pageController;
  final double gap;

  const ContentWidget(
      {super.key,
      required this.index,
      required this.pageController,
      required this.gap});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final width = size.width;
    final fem = width / AppUtils.baseWidth;

    return Column(children: [
      SizedBox(
        height: gap,
      ),
      CircleAvatar(
        radius: gap,
        backgroundColor: Colors.black,
        child: Text(
          'LOGO',
          style: TextStyle(color: Colors.white, fontSize: 14 * fem),
        ),
      ),
      SizedBox(
        height: gap,
      ),
      AnimatedBuilder(
        animation: pageController,
        builder: (context, child) {
          double page = pageController.position.hasContentDimensions
              ? pageController.page!
              : 0.0;
          return Transform.scale(
            scale: lerpDouble(1.0, 0.45, (index - page).abs().clamp(0.0, 1.0)),
            child: child,
          );
        },
        child: Image.asset(
          'images/image1.png',
          width: width * 0.5,
          height: width * 0.5,
        ),
      ),
      SizedBox(
        height: gap,
      ),
      RichText(
          text: TextSpan(children: [
        TextSpan(
            text: 'Great',
            style: TextStyle(
                color: Colors.black,
                fontSize: 24 * fem,
                fontWeight: FontWeight.w600)),
        TextSpan(
            text: ' VR Oculus',
            style: TextStyle(
                color: Colors.black54,
                fontSize: 22 * fem,
                fontWeight: FontWeight.w400))
      ])),
      SizedBox(
        height: gap,
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0 * fem),
        child: AnimatedBuilder(
          animation: pageController,
          builder: (context, child) {
            double page = pageController.position.hasContentDimensions
                ? pageController.page!
                : 0.0;
            return Opacity(
              opacity: Tween(begin: 1.0, end: 0.0)
                  .transform(((index - page) * 2).abs().clamp(0.0, 1.0)),
              child: child,
            );
          },
          child: Text(
            'Lorem ipsum dolor sit amet,consectetur adipiscing elit,sed do eiusmod tempor  nulla pariatur consectetur adipiscing elit sed do eiusmod tempor ,sed do eiusmod tempor ',
            style: TextStyle(color: Colors.black54, fontSize: 16 * fem),
            textAlign: TextAlign.center,
          ),
        ),
      )
    ]);
  }
}
