import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class TextDurationWidget extends StatelessWidget {
  final AnimationController animationController;
  final ValueNotifier<double> translateX;
  const TextDurationWidget(
      {super.key, required this.animationController, required this.translateX});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    final double fem = width / AppUtils.baseWidth;
    return AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return FadeTransition(opacity: animationController, child: child);
        },
        child: AnimatedBuilder(
          animation: translateX,
          builder: (context, child) {
            return Text(
              '${translateX.value.sign > 0 ? '+' : ''}'
              '${lerpDouble(0, 60, translateX.value)!.toInt()}s',
              style: TextStyle(color: Colors.black, fontSize: 25 * fem),
            );
          },
        ));
  }
}
