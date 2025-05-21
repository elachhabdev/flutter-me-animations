import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/models/event_important.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';
import 'package:flutter_me_animations/utils/interpolations.dart';

class EventImportantHorizontalWidget extends StatelessWidget {
  final double startYears;
  final double gapYears;
  final int column;
  final EventImportant eventImportant;
  final int numberOfYears;
  const EventImportantHorizontalWidget(
      {super.key,
      required this.gapYears,
      required this.startYears,
      required this.column,
      required this.eventImportant,
      required this.numberOfYears});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    final double fem = width / AppUtils.baseWidth;
    final double intervalEventYear = eventImportant.end - eventImportant.start;
    final double totalWidthYears = width;
    final double totalHeightYears = gapYears * (numberOfYears);

    return Positioned.fill(
      top: column * 20.0 * fem,
      left: lerpDouble(
          0.0,
          width,
          inverselerp(
              startYears, startYears + totalHeightYears, eventImportant.start)),
      child: Align(
          alignment: Alignment.topLeft,
          child: Container(
              width: lerpDouble(
                  0.0,
                  totalWidthYears,
                  inverselerp(
                      0.0,
                      totalHeightYears,
                      (intervalEventYear) <= gapYears
                          ? gapYears
                          : intervalEventYear.abs())),
              height: 10,
              decoration: BoxDecoration(
                  color: eventImportant.color,
                  borderRadius: BorderRadius.circular(15)))),
    );
  }
}
