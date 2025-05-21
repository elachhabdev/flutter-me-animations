import 'dart:math';
import 'dart:ui';

Map<String, double> cartesian2Polar(Offset point) {
  double radius = sqrt(point.dx * point.dx + point.dy * point.dy);
  double theta = atan2(point.dy, point.dx);
  return {'radius': radius, 'theta': theta};
}

Map<String, double> controlPoint(Offset current, Offset? previous, Offset? next,
    bool reverse, double smoothing) {
  Offset p = previous ?? current;
  Offset n = next ?? current;

  // Properties of the opposed-line
  double lengthX = n.dx - p.dx;
  double lengthY = n.dy - p.dy;

  var o = cartesian2Polar(Offset(lengthX, lengthY));
  // If is end-control-point, add PI to the angle to go backward
  double angle = o['theta']! + (reverse ? pi : 0);
  double length = o['radius']! * smoothing;
  // The control point position is relative to the current point
  double x = current.dx + cos(angle) * length;
  double y = current.dy + sin(angle) * length;

  return {'x': x, 'y': y};
}

Path curveLines(List<Offset> points, double smoothing, String strategy) {
  final path = Path();
  path.moveTo(points[0].dx, points[0].dy);

  for (int i = 1; i < points.length; i++) {
    final point = points[i];
    final next = i < points.length - 1 ? points[i + 1] : null;
    final prev = points[i - 1];
    final cps = controlPoint(
        prev, i > 1 ? points[i - 2] : null, point, false, smoothing);
    final cpe = controlPoint(point, prev, next, true, smoothing);

    switch (strategy) {
      case "simple":
        final cp =
            Offset((cps['x']! + cpe['x']!) / 2, (cps['y']! + cpe['y']!) / 2);
        path.quadraticBezierTo(cp.dx, cp.dy, point.dx, point.dy);
        break;
      case "bezier":
        final p0 = i > 1 ? points[i - 2] : prev;
        final p1 = points[i - 1];
        final cp1x = (2 * p0.dx + p1.dx) / 3;
        final cp1y = (2 * p0.dy + p1.dy) / 3;
        final cp2x = (p0.dx + 2 * p1.dx) / 3;
        final cp2y = (p0.dy + 2 * p1.dy) / 3;
        final cp3x = (p0.dx + 4 * p1.dx + point.dx) / 6;
        final cp3y = (p0.dy + 4 * p1.dy + point.dy) / 6;
        path.cubicTo(cp1x, cp1y, cp2x, cp2y, cp3x, cp3y);
        if (i == points.length - 1) {
          path.cubicTo(
              points[points.length - 1].dx,
              points[points.length - 1].dy,
              points[points.length - 1].dx,
              points[points.length - 1].dy,
              points[points.length - 1].dx,
              points[points.length - 1].dy);
        }
        break;
      case "complex":
        path.cubicTo(
            cps['x']!, cps['y']!, cpe['x']!, cpe['y']!, point.dx, point.dy);
        break;
    }
  }
  return path;
}
