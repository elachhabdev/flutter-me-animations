import 'package:flutter/material.dart';
import 'package:flutter_me_animations/models/slide.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class TitleDetailWidget extends StatelessWidget {
  final Slide slide;
  final List<String> title;
  final AnimationController animationController;

  const TitleDetailWidget(
      {super.key,
      required this.animationController,
      required this.slide,
      required this.title});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final width = size.width;
    final fem = width / AppUtils.baseWidth;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          textBaseline: TextBaseline.alphabetic,
          children: [
            ...title.asMap().entries.map((e) => AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  final step = ((1 / title.length) * e.key).toDouble() * 0.5;
                  return FadeTransition(
                    opacity: Tween(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: animationController,
                            curve: Interval(step, 1.0, curve: Curves.ease))),
                    child: SlideTransition(
                        position: Tween(
                                begin: const Offset(0.0, -0.3),
                                end: const Offset(0.0, 0.0))
                            .animate(CurvedAnimation(
                                parent: animationController,
                                curve:
                                    Interval(step, 1.0, curve: Curves.ease))),
                        child: child),
                  );
                },
                child: Text(
                  e.value,
                  style: TextStyle(
                      fontSize: 28 * fem,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )))
          ],
        ),
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return FadeTransition(
                opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: animationController,
                    curve: const Interval(0.5, 1.0, curve: Curves.ease))),
                child: SlideTransition(
                  position: Tween(
                          begin: const Offset(0.0, -0.5),
                          end: const Offset(0.0, 0.0))
                      .animate(CurvedAnimation(
                          parent: animationController,
                          curve: const Interval(0.5, 1.0, curve: Curves.ease))),
                  child: child,
                ));
          },
          child: Padding(
            padding: EdgeInsets.only(left: 5 * fem),
            child: Text(
              'CASQUE VR',
              style: TextStyle(
                  fontSize: 12 * fem,
                  fontWeight: FontWeight.bold,
                  color: slide.color),
            ),
          ),
        )
      ],
    );
  }
}
