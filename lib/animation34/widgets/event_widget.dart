import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation34/widgets/event_box_widget.dart';
import 'package:flutter_me_animations/models/event.dart';
import 'package:flutter_me_animations/utils/interpolations.dart';

class EventWidget extends StatelessWidget {
  final double startYears;
  final double gapYears;
  final int index;
  final List<Event> events;
  final int gapInYearsBetweenEvent;
  final ValueNotifier<String> currentYearEvent;
  final ValueNotifier<double> currentYear;
  final AnimationController animationController;

  const EventWidget(
      {super.key,
      required this.gapYears,
      required this.index,
      required this.startYears,
      required this.events,
      required this.gapInYearsBetweenEvent,
      required this.currentYearEvent,
      required this.currentYear,
      required this.animationController});

  @override
  Widget build(BuildContext context) {
    double interval = startYears + index * gapYears;
    double nextinterval = startYears + (index + 1) * gapYears;

    return Stack(
      children: [
        ...events.where((event) => event.interval == interval).map((e) {
          return Align(
              alignment: AlignmentGeometry.lerp(
                  Alignment.topLeft,
                  Alignment.bottomLeft,
                  inverselerp(interval, nextinterval, e.year))!,
              child: RepaintBoundary(
                child: EventBoxWidget(
                    currentYear: currentYear,
                    currentYearEvent: currentYearEvent,
                    gapInYearsBetweenEvent: gapInYearsBetweenEvent,
                    gapYears: gapYears,
                    startYears: startYears,
                    animationController: animationController,
                    event: e),
              ));
        })
      ],
    );
  }
}
