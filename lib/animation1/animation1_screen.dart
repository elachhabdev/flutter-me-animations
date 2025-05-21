import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_me_animations/models/movie.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class Animation1Screen extends StatefulWidget {
  const Animation1Screen({super.key});

  @override
  State<Animation1Screen> createState() => _Animation1ScreenState();
}

class _Animation1ScreenState extends State<Animation1Screen>
    with SingleTickerProviderStateMixin {
  final List<Movie> movies = const [
    Movie(index: 0, title: 'Movie 1', image: 'movie1.jpg'),
    Movie(index: 1, title: 'Movie 2', image: 'movie2.jpg'),
    Movie(index: 2, title: 'Movie 3', image: 'movie3.jpg'),
    Movie(index: 3, title: 'Movie 4', image: 'movie4.jpg'),
    Movie(index: 4, title: 'Movie 5', image: 'movie5.jpg'),
  ];

  final ValueNotifier<double> translateX = ValueNotifier(0.0);

  final ValueNotifier<double> page = ValueNotifier(0.0);

  Offset startpos = Offset.zero;

  Offset endpos = Offset.zero;

  late AnimationController animationController;

  late double containerWidth;

  late double gap;

  late double width;

  late double height;

  late double fem;

  double currentPage = 0.0;

  decay() {
    translateX.value = animationController.value
        .clamp(-(containerWidth + gap) * (movies.length - 1), 0.0);

    page.value = (translateX.value / (containerWidth + gap)).abs();
  }

  fling() {
    translateX.value = animationController.value
        .clamp(-(containerWidth + gap) * (movies.length - 1), 0.0);

    page.value = (translateX.value / (containerWidth + gap)).abs();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController.unbounded(vsync: this);
    animationController.addListener(fling);
  }

  @override
  void didChangeDependencies() {
    final Size size = MediaQuery.of(context).size;

    width = size.width;
    height = size.height;
    fem = width / AppUtils.baseWidth;
    containerWidth = width * 0.6;
    gap = 30 * fem;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    translateX.dispose();
    page.dispose();
    animationController.removeListener(fling);
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(gap),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello,Elachhab',
                    style: TextStyle(
                        fontSize: 18 * fem, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Welcome to me animations',
                    style: TextStyle(fontSize: 16 * fem, color: Colors.black54),
                  )
                ],
              ),
              const Spacer(),
              GestureDetector(
                onPanStart: (details) {
                  if (animationController.isAnimating) {
                    animationController.stop();
                  }

                  startpos = endpos = details.localPosition;
                },
                onPanUpdate: (details) {
                  endpos = details.localPosition;
                  translateX.value = (translateX.value + details.delta.dx)
                      .clamp(
                          -(containerWidth + gap) * (movies.length - 1), 0.0);

                  page.value =
                      (translateX.value / (containerWidth + gap)).abs();
                },
                onPanEnd: (details) {
                  //if you want decay with velocity

/*                   final velocity = details.velocity.pixelsPerSecond;
 
                      final double snap = dir.dx > 0.0
                      ? snapedFinalX.round() * itemWidth
                      : (snapedFinalX.floor() * itemWidth);
                      
                      velocity.dx*sensitivity;
 */

                  //fling

                  Offset moveDelta = endpos - startpos;

                  final distance = moveDelta.distance;

                  if (distance == 0.0) {
                    return;
                  }

                  moveDelta /= distance;

                  final dir = Offset(
                    moveDelta.dx.roundToDouble(),
                    moveDelta.dy.roundToDouble(),
                  );

                  final itemWidth = (containerWidth + gap);

                  final velocity = Offset(
                      dir.dx > 0.0 ? itemWidth * 0.7 : itemWidth * 0.1, 0.0);

                  final frictionSimulation =
                      FrictionSimulation(0.4, translateX.value, velocity.dx);

                  final snapedFinalX = (frictionSimulation.finalX / itemWidth);

                  final double snap = snapedFinalX.floor() * itemWidth;

                  final springsimulation = SpringSimulation(
                      SpringDescription.withDampingRatio(
                        mass: 1.0,
                        stiffness: 1000.0,
                        ratio: 2.0,
                      ),
                      translateX.value,
                      snap,
                      0.1);

                  animationController.animateWith(springsimulation);

                  //fling
                },
                child: RepaintBoundary(
                  child: Stack(
                    children: [
                      ...movies.reversed.map(
                        (e) => AnimatedBuilder(
                          animation: page,
                          builder: (context, child) {
                            final percent = page.value - e.index;
                            return Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..translate(e.index < page.value
                                    ? lerpDouble(0.0, -3 * gap - containerWidth,
                                        percent.clamp(0.0, 1.0))
                                    : gap * -percent)
                                ..scale(e.index < page.value
                                    ? lerpDouble(
                                        1.0, 0.7, percent.clamp(0.0, 1.0))
                                    : (1 + percent * 0.08)),
                              child: Opacity(
                                opacity: (1 + percent * 0.3).clamp(0.0, 1.0),
                                child: child,
                              ),
                            );
                          },
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                'images/${e.image}',
                                fit: BoxFit.cover,
                                width: containerWidth,
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 5 * fem,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.blueGrey.shade900,
                    borderRadius: BorderRadius.circular(30 * fem)),
                height: 60 * fem,
                padding: EdgeInsets.all(10 * fem),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 25,
                      child: Icon(
                        Icons.home_outlined,
                        color: Colors.blueGrey.shade700,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
