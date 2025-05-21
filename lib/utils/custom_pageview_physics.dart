import 'package:flutter/material.dart';

class CustomPageviewPhysics extends ScrollPhysics {
  const CustomPageviewPhysics({super.parent});

  @override
  CustomPageviewPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageviewPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => SpringDescription.withDampingRatio(
        mass: 1.0,
        stiffness: 1000.0,
        ratio: 1.7,
      );
}
