import 'dart:math';

import 'package:flutter/material.dart';

class LeadContentWidget extends StatelessWidget {
  final int index;
  final int minutes;
  final int hours;
  final double fem;
  final double containerHeight;
  final ValueNotifier<double> page;
  const LeadContentWidget(
      {super.key,
      required this.index,
      required this.minutes,
      required this.containerHeight,
      required this.fem,
      required this.hours,
      required this.page});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 100 * fem,
        height: containerHeight,
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
                right: -20 * fem,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AnimatedBuilder(
                    animation: page,
                    builder: (context, child) {
                      return Container(
                          width: 20 * fem,
                          height: 20 * fem,
                          decoration: BoxDecoration(
                              color: Color.lerp(Colors.teal, Colors.indigo,
                                  (page.value - index).abs().clamp(0.0, 1.0)),
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8))),
                          child: child);
                    },
                    child: Transform.rotate(
                      angle: pi / 2,
                      child: Icon(
                        Icons.airplanemode_active,
                        color: Colors.white,
                        size: 17 * fem,
                      ),
                    ),
                  ),
                )),
            AnimatedBuilder(
              animation: page,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.teal,
                    Color.lerp(Colors.teal, Colors.indigo,
                        (page.value - index).abs().clamp(0.0, 1.0))!
                  ])),
                  alignment: Alignment.center,
                  child: child,
                );
              },
              child: Text(
                '$hours : ${minutes == 0 ? '00' : minutes} pm ',
                style: TextStyle(
                    fontSize: 15 * fem,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
