import 'package:flutter/material.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class BoxTitleWidget extends StatelessWidget {
  final AnimationController animationController;
  const BoxTitleWidget({super.key, required this.animationController});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final width = size.width;
    final fem = width / AppUtils.baseWidth;

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve: const Interval(0.5, 1.0, curve: Curves.ease))),
          child: SlideTransition(
            position: Tween(
                    begin: const Offset(0.7, 0.0), end: const Offset(0.0, 0.0))
                .animate(CurvedAnimation(
                    parent: animationController,
                    curve: const Interval(0.5, 1.0, curve: Curves.ease))),
            child: child,
          ),
        );
      },
      child: Container(
        color: Colors.white,
        width: 100 * fem,
        padding: EdgeInsets.all(10 * fem),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Advertising Turkey',
                style:
                    TextStyle(fontSize: 14 * fem, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(
                    'Play',
                    style: TextStyle(
                        fontSize: 14 * fem, fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.play_arrow)
                ],
              )
            ]),
      ),
    );
  }
}
