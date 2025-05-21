import 'package:flutter/material.dart';

class ContentWidget extends StatelessWidget {
  final int index;
  final int minutes;
  final int hours;
  final double fem;
  final double containerHeight;
  const ContentWidget(
      {super.key,
      required this.index,
      required this.minutes,
      required this.containerHeight,
      required this.fem,
      required this.hours});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: containerHeight,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Flight ${index + 1}',
              style: TextStyle(
                  fontSize: 18 * fem,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Leave by $hours : ${minutes == 0 ? '00' : minutes} pm',
              style: TextStyle(
                  fontSize: 14 * fem,
                  color: Colors.white54,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
