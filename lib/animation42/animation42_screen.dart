import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation42/widgets/line_plot_widget.dart';
import 'package:flutter_me_animations/models/point.dart';
import 'package:flutter_me_animations/utils/curves_bezier.dart';
import 'package:flutter_me_animations/utils/interpolate_path.dart';

class Animation42Screen extends StatefulWidget {
  const Animation42Screen({super.key});

  @override
  State<Animation42Screen> createState() => _Animation42ScreenState();
}

class _Animation42ScreenState extends State<Animation42Screen>
    with SingleTickerProviderStateMixin {
  double get screenPixelRatio =>
      ui.PlatformDispatcher.instance.views.first.devicePixelRatio;

  double get screenWidthPixels =>
      ui.PlatformDispatcher.instance.views.first.physicalSize.shortestSide;

  double get screenHeightPixels =>
      ui.PlatformDispatcher.instance.views.first.physicalSize.longestSide;

  double get width => (screenWidthPixels / screenPixelRatio);

  double get height => (screenHeightPixels / screenPixelRatio);

  bool isdragging = false;

  int start = 0;

  int end = 0;

  final List<Path> paths = [];

  final List<List<Point>> lPoints = [];

  late SampledPathData data;

  late AnimationController animationController;

  final ValueNotifier<double> x = ValueNotifier(0.0);

  void func(int i, Offset z) {
    setState(() {
      data.shiftedPoints[i] = z;
    });
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 4; i++) {
      List<Point> points = List.generate(
          14,
          (index) => Point(
              date: '2024-01-${(8 * (index + 1) % 7)}',
              price: ui.lerpDouble(-4000.0, 6000.0, Random().nextDouble())!));

      lPoints.add(points);

      List<double> prices = points.map((p) => p.price.abs()).toList();

      double totalPrice = prices.reduce(max);

      int totalDays = points.length;

      List<Offset> ps = List.generate(
          points.length,
          (i) => Offset(
              ui.lerpDouble(0.0, width, i / (totalDays - 1))!,
              ui.lerpDouble(height * 0.3 - 20, 20,
                  (points[i].price.abs()) / totalPrice)!));

      Path path = curveLines(ps, 0.2, 'bezier');

      paths.add(path);
    }

    data = PathMorph.samplePaths(paths[0], paths[0]);

    animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onPanStart: (details) {
                setState(() {
                  isdragging = true;
                  x.value = (details.localPosition.dx);
                });
              },
              onPanUpdate: (details) {
                x.value = (details.localPosition.dx);
              },
              onPanEnd: (details) {
                setState(() {
                  isdragging = false;
                });
              },
              child: AnimatedBuilder(
                  animation: x,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size(width, height * 0.3),
                      painter: LinePlot(
                          points: lPoints[end],
                          path: PathMorph.generatePath(data),
                          x: x.value,
                          isdragging: isdragging),
                    );
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: end == 0 ? Colors.teal : Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        start = end;
                        end = 0;
                        data = PathMorph.samplePaths(paths[start], paths[end]);
                        PathMorph.generateAnimations(
                            animationController, data, func);
                        animationController.reset();
                        animationController.fling(
                            velocity: 0.1,
                            springDescription:
                                SpringDescription.withDampingRatio(
                                    mass: 1, stiffness: 1000, ratio: 1.9));
                      });
                    },
                    child: Text(
                      '1 Day',
                      style: TextStyle(
                          color: end == 0 ? Colors.white : Colors.black,
                          fontSize: 12),
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: end == 1 ? Colors.teal : Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        start = end;
                        end = 1;
                        data = PathMorph.samplePaths(paths[start], paths[end]);
                        PathMorph.generateAnimations(
                            animationController, data, func);
                        animationController.reset();
                        animationController.fling(
                            velocity: 0.1,
                            springDescription:
                                SpringDescription.withDampingRatio(
                                    mass: 1, stiffness: 1000, ratio: 1.9));
                      });
                    },
                    child: Text(
                      '1 Week',
                      style: TextStyle(
                          color: end == 1 ? Colors.white : Colors.black,
                          fontSize: 12),
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: end == 2 ? Colors.teal : Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        start = end;
                        end = 2;
                        data = PathMorph.samplePaths(paths[start], paths[end]);
                        PathMorph.generateAnimations(
                            animationController, data, func);
                        animationController.reset();

                        animationController.fling(
                            velocity: 0.1,
                            springDescription:
                                SpringDescription.withDampingRatio(
                                    mass: 1, stiffness: 1000, ratio: 1.9));
                      });
                    },
                    child: Text(
                      '1 Month',
                      style: TextStyle(
                          color: end == 2 ? Colors.white : Colors.black,
                          fontSize: 12),
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: end == 3 ? Colors.teal : Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        start = end;
                        end = 3;
                        data = PathMorph.samplePaths(paths[start], paths[end]);
                        PathMorph.generateAnimations(
                            animationController, data, func);
                        animationController.reset();

                        animationController.fling(
                            velocity: 0.1,
                            springDescription:
                                SpringDescription.withDampingRatio(
                                    mass: 1, stiffness: 1000, ratio: 1.9));
                      });
                    },
                    child: Text(
                      '1 Year',
                      style: TextStyle(
                          color: end == 3 ? Colors.white : Colors.black,
                          fontSize: 12),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
