import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/models/event.dart';

class EventBoxWidget extends StatefulWidget {
  final ValueNotifier<String> currentYearEvent;
  final ValueNotifier<double> currentYear;
  final int gapInYearsBetweenEvent;
  final AnimationController animationController;
  final double startYears;
  final double gapYears;
  final Event event;

  const EventBoxWidget(
      {super.key,
      required this.currentYearEvent,
      required this.gapInYearsBetweenEvent,
      required this.gapYears,
      required this.currentYear,
      required this.startYears,
      required this.animationController,
      required this.event});

  @override
  State<EventBoxWidget> createState() => _EventBoxWidgetState();
}

class _EventBoxWidgetState extends State<EventBoxWidget> {
  StreamController streamController = StreamController();

  bool isExpanded = false;

  showEventListener() {
    if ((widget.currentYear.value >
                widget.event.year - widget.gapInYearsBetweenEvent &&
            widget.currentYear.value <
                widget.event.year + widget.gapInYearsBetweenEvent) &&
        !isExpanded) {
      setState(() {
        isExpanded = true;
        widget.currentYearEvent.value =
            'At ${widget.event.year.toInt().abs()} ${widget.event.year >= 0 ? '' : 'B'}CE';
        widget.animationController.fling(
            velocity: 0.01,
            springDescription: SpringDescription.withDampingRatio(
              mass: 1.0,
              stiffness: 1000.0,
              ratio: 1.5,
            ));
      });
    } else if ((widget.currentYear.value <=
                widget.event.year - widget.gapInYearsBetweenEvent ||
            widget.currentYear.value >=
                widget.event.year + widget.gapInYearsBetweenEvent) &&
        isExpanded) {
      setState(() {
        isExpanded = false;
        widget.animationController.fling(
            velocity: -0.01,
            springDescription: SpringDescription.withDampingRatio(
              mass: 1.0,
              stiffness: 1000.0,
              ratio: 3.0,
            ));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.currentYear.addListener(showEventListener);
  }

  @override
  void dispose() {
    widget.currentYear.removeListener(showEventListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      transformAlignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.01)
        ..scale(isExpanded ? 5.0 : 1.0),
      duration: Duration(milliseconds: !isExpanded ? 500 : 100),
      height: 2,
      width: 2,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          blurRadius: 2,
          color: Colors.white,
          spreadRadius: !isExpanded ? 0.0 : 0.5,
        )
      ], color: Colors.orange, shape: BoxShape.circle),
    );
  }
}
