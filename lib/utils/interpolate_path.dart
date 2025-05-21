import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/utils/curves_bezier.dart';

class SampledPathData {
  late List<Offset> points1;
  late List<Offset> points2;
  late List<int> endIndices;
  late List<Offset> shiftedPoints;

  SampledPathData() {
    points1 = List<Offset>.empty(growable: true);
    points2 = List<Offset>.empty(growable: true);
    shiftedPoints = List<Offset>.empty(growable: true);
    endIndices = List<int>.empty(growable: true);
  }
}

class PathMorph {
  static SampledPathData samplePaths(Path path1, Path path2,
      {double precision = 0.01}) {
    var data = SampledPathData();
    var k = 0;
    path1.computeMetrics().forEach((metric) {
      for (var i = 0.0; i < 1.1; i += precision) {
        Tangent? tangent = metric.getTangentForOffset(metric.length * i);
        if (tangent == null) continue;
        Offset position = tangent.position;
        data.points1.add(position);
        data.shiftedPoints.add(position);
      }
    });
    path2.computeMetrics().forEach((metric) {
      data.endIndices.add(k);
      for (var i = 0.0; i < 1.1; i += precision) {
        Tangent? tangent = metric.getTangentForOffset(metric.length * i);
        if (tangent == null) continue;
        k += 1;
        data.points2.add(tangent.position);
      }
    });
    return data;
  }

  static void generateAnimations(
      AnimationController controller, SampledPathData data, Function func) {
    for (var i = 0; i < data.points1.length; i++) {
      var start = data.points1[i];
      var end = data.points2[i];
      var tween = Tween(begin: start, end: end);
      var animation = tween.animate(controller);
      animation.addListener(() {
        func(i, animation.value);
      });
    }
  }

  static Path generatePath(SampledPathData data) {
    List<Offset> ps =
        data.shiftedPoints.map((p) => Offset(p.dx, p.dy)).toList();

    return curveLines(ps, 0.2, 'bezier');
  }
}
