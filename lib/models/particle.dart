import 'dart:ui';

class Particle {
  Offset current;
  final Offset initial;
  Color color;

  Particle({required this.color, required this.current, required this.initial});

  updateCurrentPosition(Offset target, Color targetColor, double interpolator) {
    current = Offset.lerp(current, target, interpolator)!;
    color = Color.lerp(color, targetColor, interpolator)!;
  }
}
