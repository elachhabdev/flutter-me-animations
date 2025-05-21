import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class ContentWidget extends StatelessWidget {
  final List<String> items = ['Fuel', 'Electricity', 'Water'];

  final List<int> values = [66, 30, 80];

  final List<IconData> icons = [
    Icons.factory,
    Icons.electric_meter,
    Icons.water_drop
  ];

  final List<String> days = ['Mon', 'Thu', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  final ValueNotifier<double> page;

  final double containerHeight;

  ContentWidget({super.key, required this.page, required this.containerHeight});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;
    final double fem = width / AppUtils.baseWidth;

    return Positioned.fill(
      top: height * 0.5 - containerHeight * 0.5,
      left: 40 * fem,
      child: Column(
        children: [
          ...items.asMap().entries.map((e) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.value,
                    style: TextStyle(
                        fontSize: 15 * fem, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 15 * fem,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.purple.shade900,
                        radius: 14,
                        child: Icon(
                          icons[e.key],
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(
                        width: 10 * fem,
                      ),
                      AnimatedBuilder(
                          animation: page,
                          builder: (context, child) {
                            return Text(
                                lerpDouble(
                                        0.0,
                                        values[e.key],
                                        (page.value / (days.length - 1))
                                            .clamp(0.0, 1.0))!
                                    .toStringAsFixed(1),
                                style: TextStyle(
                                    fontSize: 22 * fem,
                                    fontWeight: FontWeight.w500));
                          })
                    ],
                  ),
                  SizedBox(
                    height: 15 * fem,
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 10,
                        width: width * 0.3,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(25)),
                      ),
                      AnimatedBuilder(
                          animation: page,
                          builder: (context, child) {
                            return Container(
                              height: 10,
                              width: lerpDouble(
                                  0.0,
                                  width * 0.3,
                                  lerpDouble(
                                          0.0,
                                          values[e.key],
                                          (page.value / (days.length - 1))
                                              .clamp(0.0, 1.0))! /
                                      100)!,
                              decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.circular(25)),
                            );
                          })
                    ],
                  ),
                  SizedBox(
                    height: 30 * fem,
                  )
                ],
              ))
        ],
      ),
    );
  }
}
