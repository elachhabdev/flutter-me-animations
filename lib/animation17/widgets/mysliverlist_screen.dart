import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_me_animations/utils/interpolations.dart';

class MySliverList extends SliverMultiBoxAdaptorWidget {
  const MySliverList({
    super.key,
    required super.delegate,
  });

  @override
  SliverMultiBoxAdaptorElement createElement() =>
      SliverMultiBoxAdaptorElement(this, replaceMovedChildren: true);

  @override
  MyRenderSliverList createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element =
        context as SliverMultiBoxAdaptorElement;
    return MyRenderSliverList(childManager: element);
  }
}

class MyRenderSliverList extends RenderSliverList {
  MyRenderSliverList({required super.childManager});
  final LayerHandle<TransformLayer> transformLayer =
      LayerHandle<TransformLayer>();

  @override
  void dispose() {
    transformLayer.layer = null;
    super.dispose();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (firstChild == null) {
      return;
    }
    // offset is to the top-left corner, regardless of our axis direction.
    // originOffset gives us the delta from the real origin to the origin in the axis direction.
    final Offset mainAxisUnit, crossAxisUnit, originOffset;
    final bool addExtent;
    switch (applyGrowthDirectionToAxisDirection(
        constraints.axisDirection, constraints.growthDirection)) {
      case AxisDirection.up:
        mainAxisUnit = const Offset(0.0, -1.0);
        crossAxisUnit = const Offset(1.0, 0.0);
        originOffset = offset + Offset(0.0, geometry!.paintExtent);
        addExtent = true;
      case AxisDirection.right:
        mainAxisUnit = const Offset(1.0, 0.0);
        crossAxisUnit = const Offset(0.0, 1.0);
        originOffset = offset;
        addExtent = false;
      case AxisDirection.down:
        mainAxisUnit = const Offset(0.0, 1.0);
        crossAxisUnit = const Offset(1.0, 0.0);
        originOffset = offset;
        addExtent = false;
      case AxisDirection.left:
        mainAxisUnit = const Offset(-1.0, 0.0);
        crossAxisUnit = const Offset(0.0, 1.0);
        originOffset = offset + Offset(geometry!.paintExtent, 0.0);
        addExtent = true;
    }
    RenderBox? child = firstChild;
    while (child != null) {
      final double mainAxisDelta = childMainAxisPosition(child);
      final double crossAxisDelta = childCrossAxisPosition(child);
      Offset childOffset = Offset(
        originOffset.dx +
            mainAxisUnit.dx * mainAxisDelta +
            crossAxisUnit.dx * crossAxisDelta,
        originOffset.dy +
            mainAxisUnit.dy * mainAxisDelta +
            crossAxisUnit.dy * crossAxisDelta,
      );
      if (addExtent) {
        childOffset += mainAxisUnit * paintExtentOf(child);
      }

      // If the child's visible interval (mainAxisDelta, mainAxisDelta + paintExtentOf(child))
      // does not intersect the paint extent interval (0, constraints.remainingPaintExtent), it's hidden.
      if (mainAxisDelta < constraints.remainingPaintExtent &&
          mainAxisDelta + paintExtentOf(child) > 0) {
        final double currentPosition = childScrollOffset(child)!;

        final double topEndPosition = currentPosition + child.size.height;

        final topPercent = inverselerp(
                currentPosition, topEndPosition, constraints.scrollOffset)
            .clamp(0.0, 1.0);

        final currentOffsetEnd = (currentPosition - constraints.scrollOffset);

        final bottomEndPosition =
            constraints.viewportMainAxisExtent - child.size.height;

        final isBeyondEnd = currentOffsetEnd > bottomEndPosition;

        final bottomPercent = inverselerp(constraints.viewportMainAxisExtent,
                bottomEndPosition, currentOffsetEnd)
            .clamp(0.0, 1.0);

        final Offset translate = isBeyondEnd
            ? Offset(child.size.width, bottomEndPosition)
            : Offset(child.size.width, child.size.height);

        transformLayer.layer = context.pushTransform(
            needsCompositing,
            offset,
            Matrix4.identity()
              ..translate(translate.dx, translate.dy)
              ..rotateZ(isBeyondEnd
                  ? lerpDouble(-0.4, 0.0, bottomPercent)!
                  : lerpDouble(0.0, 0.4, topPercent)!)
              ..translate(-translate.dx, -translate.dy),
            (incontext, offset) => incontext.paintChild(child!, childOffset));
      } else {
        transformLayer.layer = null;
      }

      child = childAfter(child);
    }
  }
}
