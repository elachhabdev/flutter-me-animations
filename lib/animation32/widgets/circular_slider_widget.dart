import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CircularSliderWidget extends LeafRenderObjectWidget {
  const CircularSliderWidget({super.key});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CircularSliderRender();
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    super.updateRenderObject(context, renderObject);
  }
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

  double angle = 0.0;

  Offset scrubPosition = Offset.zero;

  Offset deltaScrub = Offset.zero;

  double radius = 0.0;

  double scale = 1.0;

  final double scrubRadius = 20;

  CircularSliderRender() {
    _panGestureRecognizer
      ..onStart = (details) {
        deltaScrub = details.localPosition - scrubPosition;
      }
      ..onUpdate = (details) {
        final Offset center =
            Offset(constraints.maxWidth * 0.5, constraints.maxHeight * 0.5);

        final Offset position = details.localPosition - deltaScrub - center;

        angle = atan2(position.dy, position.dx);

        angle = angle < 0.0 ? 2 * pi + angle : angle;

        scrubPosition =
            Offset(radius * cos(angle), radius * sin(angle)) + center;

        scale = lerpDouble(1.0, 1.8, angle / (2 * pi))!;

        markNeedsPaint();
      }
      ..onEnd = (details) {};
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
    return (position - scrubPosition).distance <= scrubRadius * 1.2 * scale;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;

    const strokeWidth = 10.0;

    final circleRadius = radius;

    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Colors.blue,
          Colors.indigo,
        ],
      ).createShader(Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: circleRadius * 2 - strokeWidth,
          height: circleRadius * 2 - strokeWidth));

    final paint2 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = const LinearGradient(
        colors: [
          Colors.purple,
          Colors.cyan,
        ],
      ).createShader(Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: circleRadius * 2 - strokeWidth,
          height: circleRadius * 2 - strokeWidth));

    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), circleRadius, paint);

    canvas.drawArc(
        Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: circleRadius * 2 - strokeWidth,
            height: circleRadius * 2 - strokeWidth),
        0.0,
        angle,
        false,
        paint2);

    final text = TextPainter(
        text: TextSpan(
            text: '${lerpDouble(0, 100, angle / (2 * pi))!.toInt()} %',
            style: TextStyle(
                fontSize: 26,
                color: Color.lerp(
                    Colors.white70, Colors.white, angle / (2 * pi)))),
        textDirection: TextDirection.ltr);

    text.layout();

    text.paint(
        canvas,
        Offset(constraints.maxWidth * 0.5 - text.width * 0.5,
            constraints.maxHeight * 0.5 - text.height * 0.5));

    final translateCenter =
        Alignment.center.alongSize(Size(scrubRadius, scrubRadius));

    transformLayer.layer = context.pushTransform(
        needsCompositing,
        scrubPosition,
        Matrix4.identity()
          ..translate(translateCenter.dx, translateCenter.dy)
          ..scale(scale)
          ..translate(-translateCenter.dx, -translateCenter.dy),
        (innerContext, offset) {
      final paintOuterScrub = Paint()..color = Colors.white;

      innerContext.canvas
          .drawCircle(scrubPosition, scrubRadius * 1.2, paintOuterScrub);

      final paintScrub = Paint()
        ..color = Color.lerp(Colors.indigo, Colors.purple,
            lerpDouble(0.0, 1.0, angle / (2 * pi))!)!;

      innerContext.canvas.drawCircle(scrubPosition, scrubRadius, paintScrub);
    }, oldLayer: transformLayer.layer);
  }
}
