import 'dart:ui';

import 'package:flutter/material.dart';

class ContentWidget extends StatelessWidget {
  final ValueNotifier<double> page;
  final double fem;
  final int index;
  const ContentWidget(
      {super.key, required this.page, required this.fem, required this.index});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: AnimatedBuilder(
          animation: page,
          builder: (context, child) {
            return Transform.scale(
              alignment: Alignment.topCenter,
              scale: lerpDouble(
                  1.0, 0.9, (page.value - index).abs().clamp(0.0, 1.0))!,
              child: child,
            );
          },
          child: Container(
              margin: EdgeInsets.only(
                  bottom: 10 * fem, left: 5 * fem, right: 5 * fem),
              padding: EdgeInsets.all(15 * fem),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Album',
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * fem),
                  ),
                  Text(
                    'Modern Times',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24 * fem,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10 * fem,
                  ),
                  Row(
                    children: [
                      Text(
                        'By',
                        style: TextStyle(
                            color: Colors.black26,
                            fontWeight: FontWeight.bold,
                            fontSize: 14 * fem),
                      ),
                      SizedBox(
                        width: 10 * fem,
                      ),
                      Text(
                        'Bob dylan',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14 * fem),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15 * fem,
                  ),
                  Flexible(
                    child: Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam',
                      maxLines: 5,
                      style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.w400,
                          fontSize: 14 * fem,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  SizedBox(
                    height: 15 * fem,
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white),
                    onPressed: () {},
                    label: const Text('Play'),
                    icon: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.red,
                    ),
                  )
                ],
              ))),
    );
  }
}
