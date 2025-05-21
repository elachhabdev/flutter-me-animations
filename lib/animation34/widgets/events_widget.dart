import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation34/widgets/event_widget.dart';
import 'package:flutter_me_animations/models/event.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class EventsWidget extends StatelessWidget {
  final double gapYears;
  final double startYears;
  final int numberOfYears;
  final int gapInYearsBetweenEvent;
  final ValueNotifier<double> currentYear;
  final ValueNotifier<String> currentYearEvent;
  final List<Event> events;
  final AnimationController animationController;
  const EventsWidget(
      {super.key,
      required this.gapYears,
      required this.startYears,
      required this.numberOfYears,
      required this.gapInYearsBetweenEvent,
      required this.currentYear,
      required this.currentYearEvent,
      required this.events,
      required this.animationController});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final fem = width / AppUtils.baseWidth;
    return RepaintBoundary(
      child: Column(children: [
        ...List.generate(
            numberOfYears,
            (index) => Row(
                  children: [
                    SizedBox(
                      width: 10 * fem,
                    ),
                    SizedBox(
                      height: gapYears,
                      width: width * 0.2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${(startYears + index * gapYears).toInt()}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 14 * fem,
                            ),
                          ),
                          SizedBox(
                            width: 5 * fem,
                          ),
                          EventWidget(
                            gapYears: gapYears,
                            index: index,
                            startYears: startYears,
                            events: events,
                            gapInYearsBetweenEvent: gapInYearsBetweenEvent,
                            currentYearEvent: currentYearEvent,
                            currentYear: currentYear,
                            animationController: animationController,
                          ),
                        ],
                      ),
                    ),
                  ],
                ))
      ]),
    );
  }
}
