import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation34/widgets/event_important_widget.dart';
import 'package:flutter_me_animations/animation34/widgets/events_important_horizontal_widget.dart';
import 'package:flutter_me_animations/animation34/widgets/events_widget.dart';
import 'package:flutter_me_animations/models/event.dart';
import 'package:flutter_me_animations/models/event_important.dart';
import 'package:flutter_me_animations/models/year_important.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class Animation34Screen extends StatefulWidget {
  const Animation34Screen({super.key});

  @override
  State<Animation34Screen> createState() => _Animation34ScreenState();
}

class _Animation34ScreenState extends State<Animation34Screen>
    with SingleTickerProviderStateMixin {
  final int numberOfYears = 40;

  final double snapPointYear = 10;

  final double startYears = -3000;

  final double gapYears = 100;

  final int gapInYearsBetweenEvent = 2;

  final List<Event> events = [];

  final List<EventImportant> eventsImportant = [];

  final List<double> years = [];

  final List<YearImportant> yearsImportant = [];

  final ScrollController scrollController = ScrollController();

  late AnimationController animationController;

  final ValueNotifier<String> currentYearEvent = ValueNotifier('');

  final ValueNotifier<double> currentYear = ValueNotifier(0.0);

  final ValueNotifier<double> translateX = ValueNotifier(0.0);

  late double height;

  late double width;

  late double fem;

  bool isloading = false;

  generateevents() {
    for (int i = 0; i < numberOfYears * 0.5; i++) {
      final double year =
          startYears +
          Random().nextInt((gapYears * (numberOfYears - 2)).toInt());

      double interval = startYears;

      for (int i = 1; i < numberOfYears; i++) {
        if (startYears + (i * gapYears) > year) {
          interval = startYears + (i - 1) * gapYears;
          break;
        }
      }

      final String event = 'Lorem ipsum events $year';

      if (years.contains(year) &&
          (years.last - year).abs() <= gapInYearsBetweenEvent) {
        continue;
      }

      years.add(year);

      events.add(Event(event: event, interval: interval, year: year));
    }

    events.sort((p, n) => p.year.compareTo(n.year));
  }

  genarateimportantevents(column) {
    for (int i = 0; i < numberOfYears; i++) {
      double maxyears = startYears + (gapYears * (numberOfYears - 3)).toInt();

      double year =
          startYears +
          Random().nextInt((gapYears * (numberOfYears - 3)).toInt());

      double interval = Random().nextInt(8) * gapYears;

      double start = year;

      double end = year + interval;

      if ((yearsImportant
                  .where((yearimp) => yearimp.column == column)
                  .isNotEmpty &&
              yearsImportant
                      .where((yearimp) => yearimp.column == column)
                      .last
                      .end >=
                  start) ||
          start >= maxyears - interval) {
        continue;
      }

      yearsImportant.add(YearImportant(start: start, column: column, end: end));

      eventsImportant.add(
        EventImportant(
          color: Color.fromARGB(
            255,
            Random().nextInt(255),
            Random().nextInt(255),
            Random().nextInt(255),
          ),
          column: column,
          end: end,
          image: 'movie${Random().nextInt(5) + 1}.jpg',
          start: start,
        ),
      );
    }
  }

  scrolllistener() {
    translateX.value = lerpDouble(
      0.0,
      width,
      scrollController.offset / scrollController.position.maxScrollExtent,
    )!;

    currentYear.value =
        startYears +
        lerpDouble(0, gapYears, scrollController.offset / gapYears)!;
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this);
    scrollController.addListener(scrolllistener);
    loadEvents();
  }

  loadEvents() {
    setState(() {
      isloading = true;
    });
    generateevents();
    genarateimportantevents(1);
    genarateimportantevents(2);
    genarateimportantevents(3);
    setState(() {
      isloading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Size size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    fem = width / AppUtils.baseWidth;
  }

  @override
  void dispose() {
    currentYear.dispose();
    translateX.dispose();
    currentYearEvent.dispose();
    scrollController.removeListener(scrolllistener);
    scrollController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isloading
          ? const CircularProgressIndicator()
          : Stack(
              children: [
                SingleChildScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EventsWidget(
                            gapYears: gapYears,
                            startYears: startYears,
                            numberOfYears: numberOfYears,
                            gapInYearsBetweenEvent: gapInYearsBetweenEvent,
                            currentYear: currentYear,
                            currentYearEvent: currentYearEvent,
                            events: events,
                            animationController: animationController,
                          ),
                          SizedBox(width: 20 * fem),
                          EventImportantWidget(
                            column: 1,
                            currentYear: currentYear,
                            eventImportants: eventsImportant,
                            gapYears: gapYears,
                            numberOfYears: numberOfYears,
                            startYears: startYears,
                          ),
                          SizedBox(width: 10 * fem),
                          EventImportantWidget(
                            column: 2,
                            currentYear: currentYear,
                            eventImportants: eventsImportant,
                            gapYears: gapYears,
                            numberOfYears: numberOfYears,
                            startYears: startYears,
                          ),
                          SizedBox(width: 10 * fem),
                          EventImportantWidget(
                            column: 3,
                            currentYear: currentYear,
                            eventImportants: eventsImportant,
                            gapYears: gapYears,
                            numberOfYears: numberOfYears,
                            startYears: startYears,
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.5),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(height: 0.5, color: Colors.white54),
                  ),
                ),
                Positioned.fill(
                  top: -40 * fem,
                  right: 20 * fem,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: AnimatedBuilder(
                      animation: currentYear,
                      builder: (context, child) {
                        double snapYear =
                            (currentYear.value / snapPointYear).floor() *
                            snapPointYear;

                        return Text(
                          '${snapYear.toInt().abs()} ${currentYear.value >= 0 ? '' : 'B'}CE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24 * fem,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                EventsImportantHorizontalWidget(
                  eventsImportant: eventsImportant,
                  gapYears: gapYears,
                  numberOfYears: numberOfYears,
                  startYears: startYears,
                  translateX: translateX,
                  scrollController: scrollController,
                ),
                AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return animationController.isDismissed
                        ? SizedBox.shrink()
                        : Positioned(
                            height: 120 * fem,
                            width: width,
                            top: 0,
                            left: 0,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.0, 0.1),
                                end: const Offset(0.0, 0.04),
                              ).animate(animationController),
                              child: FadeTransition(
                                opacity: animationController,
                                child: child,
                              ),
                            ),
                          );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade200,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: AnimatedBuilder(
                      animation: currentYearEvent,
                      builder: (context, child) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentYearEvent.value,
                              style: TextStyle(
                                fontSize: 14 * fem,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const VerticalDivider(color: Colors.blueGrey),
                            child!,
                          ],
                        );
                      },
                      child: Flexible(
                        child: Text(
                          'Lorem ipsum dolor sit amet elit, ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                          style: TextStyle(fontSize: 14 * fem),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
