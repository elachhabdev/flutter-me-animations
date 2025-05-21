import 'package:flutter/material.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class CardWidget extends StatelessWidget {
  final double containerHeight;
  final double gap;
  final ValueNotifier<double> page;
  final int index;
  const CardWidget(
      {super.key,
      required this.containerHeight,
      required this.gap,
      required this.page,
      required this.index});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final width = size.width;
    final fem = width / AppUtils.baseWidth;

    return RepaintBoundary(
      child: Stack(fit: StackFit.expand, children: [
        Container(
            height: containerHeight,
            margin: EdgeInsets.all(gap),
            padding: EdgeInsets.all(25 * fem),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(25)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CircleAvatar(
                backgroundColor: Colors.purple.shade900,
                radius: 25,
                child: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10 * fem,
              ),
              Text(
                'Maintenace',
                style: TextStyle(
                    fontSize: 28 * fem, color: Colors.purple.shade900),
              ),
              SizedBox(
                height: 10 * fem,
              ),
              Row(
                children: [
                  Icon(
                    Icons.timelapse_rounded,
                    color: Colors.purple.shade900,
                  ),
                  SizedBox(
                    width: 10 * fem,
                  ),
                  Text(
                    '4pm - 5pm',
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w500,
                        fontSize: 14 * fem),
                  )
                ],
              ),
              SizedBox(
                height: 10 * fem,
              ),
              Row(
                children: [
                  Icon(
                    Icons.timelapse_rounded,
                    color: Colors.purple.shade900,
                  ),
                  SizedBox(
                    width: 10 * fem,
                  ),
                  Text(
                    '4pm - 5pm',
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w500,
                        fontSize: 14 * fem),
                  )
                ],
              ),
              SizedBox(
                height: 10 * fem,
              ),
              Row(
                children: [
                  Icon(
                    Icons.timelapse_rounded,
                    color: Colors.purple.shade900,
                  ),
                  SizedBox(
                    width: 10 * fem,
                  ),
                  Text(
                    '4pm - 5pm',
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w500,
                        fontSize: 14 * fem),
                  )
                ],
              )
            ])),
        AnimatedBuilder(
          animation: page,
          builder: (context, child) {
            return Opacity(
                opacity: Tween(begin: 1.0, end: 0.0).transform(
                    (1 - (index - page.value) * 0.3).clamp(0.0, 1.0)),
                child: child);
          },
          child: Container(
            margin: EdgeInsets.all(gap),
            padding: EdgeInsets.all(25 * fem),
            decoration: BoxDecoration(
                color: Colors.purple.shade900.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(25)),
          ),
        ),
      ]),
    );
  }
}
