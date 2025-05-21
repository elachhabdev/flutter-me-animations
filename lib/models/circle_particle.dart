import 'dart:ui';

class CircleParticle {
  int index;
  Offset current;
  Color color;
  double radius;
  CircleParticle(
      {required this.index,
      required this.color,
      required this.current,
      required this.radius});

  updateCurrentPosition(Offset target, Color targetColor, double targetRadius,
      double interpolator) {
    current = Offset.lerp(current, target, interpolator)!;
  }

  setCurrentPosition(Offset target) {
    current = target;
  }
}
