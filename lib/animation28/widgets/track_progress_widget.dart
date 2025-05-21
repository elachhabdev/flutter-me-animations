import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class TrackProgressWidget extends StatelessWidget {
  final AnimationController animationController2;
  final double gap;

  const TrackProgressWidget(
      {super.key, required this.animationController2, required this.gap});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    final double fem = width / AppUtils.baseWidth;
    return Container(
      width: width,
      height: 60 * fem,
      margin: EdgeInsets.symmetric(horizontal: gap),
      child: Stack(
        children: [
          const Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              alignment: Alignment.center,
              child: Text(
                'David Bowie',
                style: TextStyle(
                    color: Colors.black26, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: animationController2,
              builder: (context, child) {
                return ClipPath(
                  clipper: CustomPath(value: animationController2.value),
                  child: child,
                );
              },
              child: const FittedBox(
                fit: BoxFit.cover,
                alignment: Alignment.center,
                child: Text(
                  'David Bowie',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: animationController2,
            builder: (context, child) {
              return Transform.translate(
                  offset: Offset(
                      lerpDouble(
                          0.0, width - 2 * gap, animationController2.value)!,
                      0.0),
                  child: child);
            },
            child: Container(
              height: 100 * fem,
              width: 2,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}

class CustomPath extends CustomClipper<Path> {
  double value = 0.0;

  CustomPath({required this.value});
  @override
  Path getClip(Size size) {
    final path = Path();

    path.addRect(Rect.fromLTWH(0, 0, size.width * value, size.height));

    return path;
  }

  @override
  bool shouldReclip(covariant CustomPath oldClipper) {
    return value != oldClipper.value;
  }
}
