import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation15/widgets/curved_paint_widget.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';
import 'package:flutter_me_animations/utils/interpolations.dart';

class AnimatedCurvedPaint extends ImplicitlyAnimatedWidget {
  final double position;
  final double x;
  final double y;

  const AnimatedCurvedPaint({
    super.key,
    required this.position,
    required super.duration,
    required super.curve,
    required this.x,
    required this.y,
  });

  @override
  AnimatedCurvedPaintState createState() => AnimatedCurvedPaintState();
}

class AnimatedCurvedPaintState
    extends AnimatedWidgetBaseState<AnimatedCurvedPaint> {
  Tween<double>? positionTween;

  double get height => MediaQuery.of(context).size.height;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    positionTween = visitor(positionTween, widget.position,
        (dynamic value) => Tween<double>(begin: value)) as Tween<double>?;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final fem = width / AppUtils.baseWidth;
    return CustomPaint(
      painter: CurvedPaintWidget(
          x: widget.x,
          y: widget.y,
          position: positionTween?.evaluate(animation) ?? 0.0),
      child: Align(
        alignment: Alignment(
            0.0,
            inverselerp(height * 0.1, height * 0.9,
                (positionTween?.evaluate(animation) ?? 0.0))),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          const SizedBox(
            width: 5,
          ),
          Transform.scale(
            alignment: Alignment.center,
            scale: lerpDouble(
                3.5,
                1.0,
                inverselerp(height * 0.1, height * 0.9,
                    (positionTween?.evaluate(animation) ?? 0.0)))!,
            child: Text(
              '${lerpDouble(100.0, 0.0, inverselerp(height * 0.1, height * 0.9, (positionTween?.evaluate(animation) ?? 0.0)))!.toInt()}',
              style: TextStyle(color: Colors.white, fontSize: 30 * fem),
            ),
          ),
          Text('Your Points',
              style: TextStyle(color: Colors.white, fontSize: 30 * fem)),
        ]),
      ),
    );
  }
}
