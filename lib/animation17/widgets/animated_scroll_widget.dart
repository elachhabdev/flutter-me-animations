import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_me_animations/utils/interpolations.dart';

class ScrollAnimatedWidget extends SingleChildRenderObjectWidget {
  final int index;
  final double paddingTop;
  const ScrollAnimatedWidget(
      {super.key, super.child, required this.paddingTop, required this.index});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return ScrollAnimatedRenderBox(index: index, paddingTop: paddingTop)
      ..updateScrollOffset();
  }

  @override
  void updateRenderObject(
      BuildContext context, ScrollAnimatedRenderBox renderObject) {
    renderObject.updateScrollOffset();
  }
}

class ScrollAnimatedRenderBox extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  final LayerHandle<TransformLayer> transformLayer =
      LayerHandle<TransformLayer>();

  final int index;
  final double paddingTop;

  ScrollAnimatedRenderBox({required this.index, required this.paddingTop});

  @override
  void dispose() {
    transformLayer.layer = null;
    super.dispose();
  }

  void updateScrollOffset() {
    markNeedsPaint();
  }

  @override
  void performLayout() {
    if (child != null) {
      child!.layout(constraints, parentUsesSize: true);
      size = child!.size;
    } else {
      size = constraints.biggest;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      final renderView = owner!.rootNode as RenderView;

      final screenSize = renderView.size;

      final position = child!.localToGlobal(Offset.zero).dy;

      final double topPercent =
          inverselerp(paddingTop, paddingTop - child!.size.height, position)
              .clamp(0.0, 1.0);

      final isBottom = position <= (screenSize.height - paddingTop) &&
          position >= (screenSize.height - paddingTop) - child!.size.height;

      final double bottomPercent = inverselerp(screenSize.height,
              screenSize.height - child!.size.height, position)
          .clamp(0.0, 1.0);

/*       final translateCenter = Alignment.center.alongSize(child!.size);
 */
      context.pushOpacity(
          offset,
          ((isBottom
                      ? lerpDouble(0.1, 1.0, bottomPercent)!
                      : lerpDouble(1.0, 0.1, topPercent)!) *
                  255)
              .truncate(),
          (context, offset) => context.paintChild(child!, offset));

      /* transformLayer.layer = context.pushTransform(
          needsCompositing,
          offset,
          Matrix4.identity()
            ..translate(translateCenter.dx, translateCenter.dy)
            ..scale(isBottom
                ? lerpDouble(0.5, 1.0, bottomPercent)
                : lerpDouble(1.0, 0.5, topPercent))
            ..translate(-translateCenter.dx, -translateCenter.dy),
          (context, offset) => context.paintChild(child!, offset),
          oldLayer: transformLayer.layer); */
    }
  }
}
