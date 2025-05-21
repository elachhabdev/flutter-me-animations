import 'package:flutter/material.dart';

class BoxImageWidget extends StatelessWidget {
  final AnimationController animationController;
  final ImageProvider imageProvider;
  const BoxImageWidget(
      {super.key,
      required this.animationController,
      required this.imageProvider});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return FadeTransition(
                opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: animationController,
                    curve: const Interval(0.5, 1.0, curve: Curves.ease))),
                child: SlideTransition(
                  position: Tween(
                          begin: const Offset(0.7, 0.0),
                          end: const Offset(0.0, 0.0))
                      .animate(CurvedAnimation(
                          parent: animationController,
                          curve: const Interval(0.5, 1.0, curve: Curves.ease))),
                  child: child,
                ));
          },
          child: Image(
            image: imageProvider,
            fit: BoxFit.cover,
          )),
    );
  }
}
