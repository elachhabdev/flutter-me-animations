import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/models/movie.dart';

class StackMoviesWidget extends StatelessWidget {
  final List<Movie> movies;
  final ValueNotifier<double> page;

  const StackMoviesWidget(
      {super.key, required this.movies, required this.page});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final width = size.width;

    return Stack(fit: StackFit.expand, children: [
      ...movies.reversed.map((e) => AnimatedBuilder(
            animation: page,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                    (e.index > page.value)
                        ? 0.0
                        : lerpDouble(0.0, width,
                            (e.index - page.value).abs().clamp(0.0, 1.0))!,
                    0.0),
                child: child,
              );
            },
            child: Image.asset(
              'images/${e.image}',
              fit: BoxFit.cover,
            ),
          )),
      const RepaintBoundary(
        child: DecoratedBox(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                0.4,
                0.6
              ],
                  colors: [
                Colors.transparent,
                Colors.white,
              ])),
        ),
      )
    ]);
  }
}
