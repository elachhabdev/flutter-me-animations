import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_me_animations/utils/interpolations.dart';

class MyStackedList extends SliverMultiBoxAdaptorWidget {
  const MyStackedList({
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

  @override
  void performLayout() {
    double maxPaintExtent = 0;

    childManager.didStartLayout();
    childManager.setDidUnderflow(false);

    if (firstChild == null) {
      addInitialChild();
    }

    RenderBox? child = firstChild;
    double childMainAxisPosition = 0.0;

    int index = 0;

    while (child != null) {
      final SliverMultiBoxAdaptorParentData childParentData =
          child.parentData as SliverMultiBoxAdaptorParentData;

      child.layout(
        constraints.asBoxConstraints(),
        parentUsesSize: true,
      );

      childMainAxisPosition = child.size.height;

      maxPaintExtent += childMainAxisPosition;

      childParentData.layoutOffset = childMainAxisPosition * index;

      child = childAfter(child);

      child ??= insertAndLayoutChild(
        constraints.asBoxConstraints(),
        after: lastChild,
      );

      index++;
    }

    double visibleExtent = (maxPaintExtent - constraints.scrollOffset)
        .clamp(0.0, constraints.remainingPaintExtent);

    geometry = SliverGeometry(
        scrollExtent: maxPaintExtent,
        paintExtent: visibleExtent,
        maxPaintExtent: visibleExtent,
        cacheExtent: visibleExtent,
        layoutExtent: visibleExtent);

    childManager.didFinishLayout();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;

    final beforeExtent =
        constraints.viewportMainAxisExtent - constraints.precedingScrollExtent;

    final totalExtent = constraints.viewportMainAxisExtent;

    final childmycount = (child!.size.height / beforeExtent) * childCount;

    final percent =
        inverselerp(beforeExtent, totalExtent, constraints.remainingPaintExtent)
            .clamp(-(1 / childmycount), 1.0);

    while (child != null) {
      final SliverMultiBoxAdaptorParentData childParentData =
          child.parentData as SliverMultiBoxAdaptorParentData;

      final layoutOffsetPercent = lerpDouble(
          childParentData.layoutOffset! * (1 / childmycount),
          childParentData.layoutOffset!,
          percent)!;

      final calculatedOffset =
          offset + Offset(0.0, layoutOffsetPercent - constraints.scrollOffset);

      context.paintChild(child, calculatedOffset);

      child = childAfter(child);
    }
  }
}
