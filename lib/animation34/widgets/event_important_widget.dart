import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/models/event_important.dart';
import 'package:flutter_me_animations/utils/interpolations.dart';

class EventImportantWidget extends StatelessWidget {
  final double gapYears;
  final int numberOfYears;
  final int column;
  final double startYears;
  final ValueNotifier<double> currentYear;
  final List<EventImportant> eventImportants;

  const EventImportantWidget(
      {super.key,
      required this.gapYears,
      required this.numberOfYears,
      required this.eventImportants,
      required this.column,
      required this.startYears,
      required this.currentYear});

  @override
  Widget build(BuildContext context) {
    final double totalHeightYears = gapYears * (numberOfYears);
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;

    return RepaintBoundary(
      child: SizedBox(
          height: totalHeightYears,
          width: width * 0.2,
          child: Stack(
            children: [
              ...eventImportants.where((e) => e.column == column).map((e) {
                final double intervalEventYear = e.end - e.start;

                final double intervalPercent =
                    (intervalEventYear).abs() / (totalHeightYears);

                return Positioned(
                  width: width * 0.2,
                  height: (intervalEventYear) <= gapYears
                      ? gapYears
                      : lerpDouble(0.0, totalHeightYears, intervalPercent),
                  top: lerpDouble(
                      0.0,
                      totalHeightYears,
                      inverselerp(
                          startYears, startYears + totalHeightYears, e.start)),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: e.color,
                            borderRadius: BorderRadius.circular(40)),
                      ),
                      AnimatedBuilder(
                          animation: currentYear,
                          builder: (context, child) {
                            return Align(
                                alignment: Alignment.lerp(
                                    Alignment.topCenter,
                                    Alignment.bottomCenter,
                                    inverselerp(
                                            e.start, e.end, currentYear.value)
                                        .clamp(0.0, 1.0))!,
                                child: child);
                          },
                          child: Container(
                            width: width * 0.2,
                            padding: const EdgeInsets.all(5),
                            height: (intervalEventYear) <= gapYears
                                ? gapYears
                                : max(
                                    lerpDouble(0.0, totalHeightYears,
                                            intervalPercent)! *
                                        0.3,
                                    gapYears),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40.0),
                              child: Image.asset(
                                'images/${e.image}',
                                fit: BoxFit.cover,
                                color: e.color,
                                colorBlendMode: BlendMode.color,
                              ),
                            ),
                          ))
                    ],
                  ),
                );
              })
            ],
          )),
    );
  }
}
