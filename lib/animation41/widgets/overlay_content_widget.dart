import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation41/widgets/myreordonablegrid_widget.dart';

Offset overlayOriginBox(BuildContext context) {
  final OverlayState overlay =
      Overlay.of(context, debugRequiredFor: context.widget);
  final RenderBox overlayBox = overlay.context.findRenderObject()! as RenderBox;
  return overlayBox.localToGlobal(Offset.zero);
}

class OverlayContentWidget extends StatelessWidget {
  const OverlayContentWidget(
      {super.key,
      required this.listState,
      required this.index,
      required this.child,
      required this.position,
      required this.size,
      required this.springAnimation,
      required this.color,
      required this.dropAnimation});

  final MyReordonableGridState listState;
  final int index;
  final Widget child;
  final Offset position;
  final Size size;
  final Color color;
  final AnimationController springAnimation;
  final AnimationController dropAnimation;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).removePadding(removeTop: true),
        child: AnimatedBuilder(
          animation: dropAnimation,
          builder: (context, child) {
            final dropPosition = listState.currentPosition;
            Offset effectivePosition = position;

            if (dropPosition != null) {
              effectivePosition = Offset.lerp(dropPosition, effectivePosition,
                  Curves.ease.transform(dropAnimation.value))!;
            }

            return Positioned(
                left: effectivePosition.dx,
                top: effectivePosition.dy,
                child: SizedBox(
                    width: size.width, height: size.height, child: child));
          },
          child: AnimatedBuilder(
            animation: springAnimation,
            builder: (context, child) {
              return Transform.scale(
                  scale: lerpDouble(1.0, 1.1, springAnimation.value)!,
                  child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.blueGrey.shade900,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: lerpDouble(0.1, 8.0,
                                    springAnimation.value.clamp(0.0, 3.0))!,
                                spreadRadius: lerpDouble(0.1, 2.0,
                                    springAnimation.value.clamp(0.0, 3.0))!)
                          ]),
                      height: size.height,
                      child: child));
            },
            child: child,
          ),
        ));
  }
}
