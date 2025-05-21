import 'dart:ui';

mix(double value, double x, double y) {
  return x * (1 - value) + y * value;
}

fract(double x) {
  return x - x.floor();
}

Color hsv2rgb(double h, double s, double v) {
  Map<String, double> K = {
    'x': 1,
    'y': 2 / 3,
    'z': 1 / 3,
    'w': 3,
  };
  Map<String, double> p = {
    'x': (fract(h + K['x']!) * 6 - K['w']).abs(),
    'y': (fract(h + K['y']!) * 6 - K['w']).abs(),
    'z': (fract(h + K['z']!) * 6 - K['w']).abs(),
  };
  Map<String, double> rgb = {
    'x': v * mix(s, K['x']!, (p['x']! - K['x']!).clamp(0, 1)),
    'y': v * mix(s, K['x']!, (p['y']! - K['x']!).clamp(0, 1)),
    'z': v * mix(s, K['x']!, (p['z']! - K['x']!).clamp(0, 1)),
  };

  int r = (rgb['x']! * 255).round();
  int g = (rgb['y']! * 255).round();
  int b = (rgb['z']! * 255).round();

  return Color.fromRGBO(r, g, b, 1.0);
}
