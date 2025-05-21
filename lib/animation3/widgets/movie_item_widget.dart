import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/models/movie.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class MovieItemWidget extends StatelessWidget {
  final Movie movie;
  final int index;
  final PageController pageController;
  final double gap;
  const MovieItemWidget(
      {super.key,
      required this.movie,
      required this.pageController,
      required this.index,
      required this.gap});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final width = size.width;
    final fem = width / AppUtils.baseWidth;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
          padding: EdgeInsets.only(bottom: 3 * gap),
          child: AnimatedBuilder(
            animation: pageController,
            builder: (context, child) {
              double page = pageController.position.hasContentDimensions
                  ? pageController.page!
                  : 0.0;
              return Transform.translate(
                offset: Offset(
                    0.0,
                    lerpDouble(
                        0.0, 5 * gap, (index - page).abs().clamp(0.0, 1.0))!),
                child: child,
              );
            },
            child: RepaintBoundary(
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: gap),
                  padding: EdgeInsets.all(gap),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        child: Image.asset(
                          'images/${movie.image}',
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: gap,
                      ),
                      Text(
                        movie.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16 * fem),
                      ),
                      SizedBox(
                        height: gap * 0.5,
                      ),
                      Text(
                        'Lorem ipsum dolor sit amet consectetur adipisicing ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black87, fontSize: 15 * fem),
                      ),
                      SizedBox(
                        height: gap * 0.5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Chip(
                            label: Text(
                              'Action',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12 * fem),
                            ),
                            backgroundColor: Colors.black,
                          ),
                          Chip(
                            label: Text(
                              'Action',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12 * fem),
                            ),
                            backgroundColor: Colors.black,
                          ),
                          Chip(
                            label: Text(
                              'Action',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12 * fem),
                            ),
                            backgroundColor: Colors.black,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 2 * gap,
                      )
                    ],
                  )),
            ),
          )),
    );
  }
}
