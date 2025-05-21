import 'dart:ui';

import 'package:flutter/material.dart';

class MyCustomClipper extends CustomClipper<Path> {
  final double value;

  MyCustomClipper({required this.value});

  @override
  getClip(Size size) {
    final path = Path()
      ..addRect(Rect.fromCenter(
          center: Offset(
              lerpDouble(size.width / 2, 0.0, 1 - value)!, size.height / 2),
          width: lerpDouble(size.width, 0.0, 1 - value)!,
          height: size.height));

    return path;
  }

  @override
  bool shouldReclip(covariant MyCustomClipper oldClipper) {
    return oldClipper.value != value;
  }
}
