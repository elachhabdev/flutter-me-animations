import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class CardWidget extends StatelessWidget {
  final int index;
  final ValueNotifier<double> page;
  final double containerHeight;
  final int itemsCount;
  const CardWidget(
      {super.key,
      required this.index,
      required this.page,
      required this.containerHeight,
      required this.itemsCount});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final width = size.width;
    final fem = width / AppUtils.baseWidth;
    return RepaintBoundary(
      child: Container(
        height: containerHeight,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white54)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedBuilder(
                animation: page,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(
                          alpha: lerpDouble(
                              1.0,
                              0.0,
                              (((index - page.value) / itemsCount)
                                  .clamp(0.0, 1.0)))),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Now',
                        style: TextStyle(
                            color: Colors.white38, fontSize: 12 * fem),
                      ),
                      Text(
                        'End at 13:30',
                        style: TextStyle(
                            color: Colors.white38, fontSize: 12 * fem),
                      )
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Check-in',
                        style:
                            TextStyle(color: Colors.white, fontSize: 16 * fem),
                      ),
                      Text(
                        '4h 30',
                        style:
                            TextStyle(color: Colors.white, fontSize: 16 * fem),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5 * fem,
                  ),
                  LinearProgressIndicator(
                    backgroundColor: Colors.white12,
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green,
                    value: 0.5,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
