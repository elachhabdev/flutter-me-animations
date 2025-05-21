import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';

class CircularSliderWidget extends LeafRenderObjectWidget {
  final TickerProvider vsync;
  const CircularSliderWidget({super.key, required this.vsync});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CircularSliderRender(vsync: vsync);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {}
}

class SliderParentData extends ContainerBoxParentData<RenderBox> {
  bool isDragging = false;
}

class CircularSliderRender extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, SliderParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, SliderParentData> {
  final PanGestureRecognizer _panGestureRecognizer = PanGestureRecognizer();

  final LayerHandle<TransformLayer> transformLayer =
      LayerHandle<TransformLayer>();

  late AnimationController animationController;

  double angle = 0.0;

  Offset scrubPosition = Offset.zero;

  Offset deltaScrub = Offset.zero;

  double radius = 0.0;

  double scale = 1.0;

  final double scrubRadius = 20;

  scaleAnimation() {
    scale = ui.lerpDouble(1.0, 1.2, animationController.value)!;
    markNeedsPaint();
  }

  @override
  void dispose() {
    animationController.removeListener(scaleAnimation);
    animationController.dispose();
    super.dispose();
  }

  CircularSliderRender({required vsync}) {
    animationController = AnimationController.unbounded(vsync: vsync)
      ..addListener(scaleAnimation);

    _panGestureRecognizer
      ..onStart = (details) {
        deltaScrub = details.localPosition - scrubPosition;
        animationController.animateWith(SpringSimulation(
            const SpringDescription(mass: 1, stiffness: 100, damping: 4),
            0,
            1,
            0.1));
      }
      ..onUpdate = (details) {
        final Offset center =
            Offset(constraints.maxWidth * 0.5, constraints.maxHeight * 0.5);

        final Offset position = details.localPosition - deltaScrub - center;

        angle = atan2(position.dy, position.dx);

        angle = angle < 0.0 ? 2 * pi + angle : angle;

        scrubPosition =
            Offset(radius * cos(angle), radius * sin(angle)) + center;

        markNeedsPaint();
      }
      ..onEnd = (details) {
        animationController.animateWith(SpringSimulation(
            const SpringDescription(mass: 1, stiffness: 100, damping: 4),
            1,
            0,
            -0.1));
      };
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void detach() {
    _panGestureRecognizer.dispose();
    super.detach();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! SliderParentData) {
      child.parentData = SliderParentData();
    }
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      _panGestureRecognizer.addPointer(event);
    }
  }

  @override
  void performLayout() {
    radius = constraints.maxWidth * 0.8 * 0.5;
    scrubPosition = Offset(constraints.maxWidth * 0.8 + 2 * scrubRadius,
        constraints.maxHeight * 0.5);
    size = Size(constraints.maxWidth, constraints.maxHeight);
  }

  @override
  bool hitTestSelf(Offset position) {
    return (position - scrubPosition).distance <= scrubRadius;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    final center =
        Offset(constraints.maxWidth * 0.5, constraints.maxHeight * 0.5);

    for (int i = 0; i < 360; i += 4) {
      double angleTodeg = angle * (180 / pi);

      final x = radius * cos(i * pi / 180);
      final y = radius * sin(i * pi / 180);
      if (i <= angleTodeg) {
        final xOut = x * 0.6 + center.dx;
        final yOut = y * 0.6 + center.dy;

        final xIn = xOut + x * 0.2;
        final yIn = yOut + y * 0.2;

        final path = Path()
          ..moveTo(xOut, yOut)
          ..lineTo(xIn, yIn);

        final paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..shader = ui.Gradient.linear(Offset(xIn, yIn), Offset(xOut, yOut),
              [Colors.white, Colors.transparent]);

        canvas.drawPath(path, paint);
      }
    }
    final text = TextPainter(
        text: TextSpan(
            text: '${ui.lerpDouble(0, 100, angle / (2 * pi))!.toInt()} %',
            style: TextStyle(
                fontSize: 26,
                color: Color.lerp(
                    Colors.white70, Colors.white, angle / (2 * pi)))),
        textDirection: TextDirection.ltr);

    text.layout();

    text.paint(canvas,
        Offset(center.dx - text.width * 0.5, center.dy - text.height * 0.5));

    final text2 = TextPainter(
        text: TextSpan(
            text: 'choose a value',
            style: TextStyle(fontSize: 16, color: Colors.amber.shade800)),
        textDirection: TextDirection.ltr);

    text2.layout();

    text2.paint(canvas,
        Offset(center.dx - text2.width * 0.5, center.dy + text2.height));

    final paint = Paint()
      ..color = Colors.amber.shade900
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final paint2 = Paint()
      ..color = Colors.amber.shade900
      ..style = PaintingStyle.fill;

    final translateCenter =
        Alignment.center.alongSize(Size(scrubRadius * 0.5, scrubRadius * 0.5));

    transformLayer.layer = context.pushTransform(
        needsCompositing,
        scrubPosition,
        Matrix4.identity()
          ..translate(translateCenter.dx, translateCenter.dy)
          ..scale(scale)
          ..translate(-translateCenter.dx, -translateCenter.dy),
        (innerContext, offset) {
      innerContext.canvas.drawCircle(scrubPosition, scrubRadius * 0.8, paint2);

      innerContext.canvas.drawCircle(scrubPosition, scrubRadius, paint);
    }, oldLayer: transformLayer.layer);
  }
}
