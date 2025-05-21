import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation34/widgets/event_important_horizontal_widget.dart';
import 'package:flutter_me_animations/models/event_important.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class EventsImportantHorizontalWidget extends StatelessWidget {
  final double startYears;
  final ValueNotifier<double> translateX;
  final List<EventImportant> eventsImportant;
  final ScrollController scrollController;
  final double gapYears;
  final int numberOfYears;

  const EventsImportantHorizontalWidget(
      {super.key,
      required this.eventsImportant,
      required this.gapYears,
      required this.numberOfYears,
      required this.startYears,
      required this.translateX,
      required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    final double fem = width / AppUtils.baseWidth;
    return Positioned.fill(
      bottom: 0,
      child: GestureDetector(
        onPanUpdate: (details) {
          translateX.value =
              (translateX.value + details.delta.dx).clamp(0.0, (width));

          scrollController.jumpTo(lerpDouble(
              0.0,
              scrollController.position.maxScrollExtent,
              (translateX.value / (width)).clamp(0.0, 1.0))!);
        },
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 100 * fem,
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.black, Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter)),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                    ),
                  ),
                ),
                ...eventsImportant.where((e) => e.column == 1).map((e) =>
                    EventImportantHorizontalWidget(
                        gapYears: gapYears,
                        startYears: startYears,
                        column: e.column,
                        eventImportant: e,
                        numberOfYears: numberOfYears)),
                ...eventsImportant.where((e) => e.column == 2).map((e) =>
                    EventImportantHorizontalWidget(
                        gapYears: gapYears,
                        startYears: startYears,
                        column: e.column,
                        eventImportant: e,
                        numberOfYears: numberOfYears)),
                ...eventsImportant.where((e) => e.column == 3).map((e) =>
                    EventImportantHorizontalWidget(
                        gapYears: gapYears,
                        startYears: startYears,
                        column: e.column,
                        eventImportant: e,
                        numberOfYears: numberOfYears)),
                RepaintBoundary(
                  child: AnimatedBuilder(
                      animation: translateX,
                      builder: (context, child) {
                        return Align(
                            alignment: AlignmentGeometry.lerp(
                                Alignment.centerLeft,
                                Alignment.centerRight,
                                translateX.value / (width))!,
                            child: child);
                      },
                      child: Container(
                        width: 50 * fem,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white)),
                      )),
                ),
                RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: translateX,
                    builder: (context, child) => Align(
                      alignment: AlignmentGeometry.lerp(Alignment.centerLeft,
                          Alignment.centerRight, translateX.value / (width))!,
                      child: child,
                    ),
                    child: Container(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
