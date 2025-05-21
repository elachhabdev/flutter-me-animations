import 'package:flutter/material.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class BoxWidget extends StatelessWidget {
  final Animation<double> animationOpacity;
  const BoxWidget({super.key, required this.animationOpacity});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final width = size.width;
    final fem = width / AppUtils.baseWidth;

    return FadeTransition(
      opacity: animationOpacity,
      child: Padding(
        padding: EdgeInsets.all(15 * fem),
        child: Align(
          alignment: Alignment.topLeft,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: 'Great',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18 * fem,
                      fontWeight: FontWeight.w600)),
              TextSpan(
                  text: ' VR Oculus',
                  style: TextStyle(
                      color: Colors.white54,
                      fontSize: 16 * fem,
                      fontWeight: FontWeight.w400))
            ])),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Chip(label: Text('flutter')),
                SizedBox(
                  width: 10 * fem,
                ),
                const Chip(label: Text('flutter')),
                SizedBox(
                  width: 10 * fem,
                ),
                const Chip(label: Text('flutter')),
              ],
            ),
            SizedBox(
              height: 10 * fem,
            ),
            Text(
              'Lorem ipsum dolor sit amet,consectetur adipiscing elit,sed do eiusmod tempor  nulla pariatur consectetur adipiscing elit sed do eiusmod tempor ,sed do eiusmod tempor ',
              style: TextStyle(color: Colors.white60, fontSize: 16 * fem),
            ),
            SizedBox(
              height: 10 * fem,
            ),
          ]),
        ),
      ),
    );
  }
}
