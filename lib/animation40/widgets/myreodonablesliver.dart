import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyReordonableSliverGrid extends SliverMultiBoxAdaptorWidget {
  MyReordonableSliverGrid({
    super.key,
    required this.gridDelegate,
    required NullableIndexedWidgetBuilder itemBuilder,
    ChildIndexGetter? findChildIndexCallback,
    int? itemCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
  }) : super(
            delegate: SliverChildBuilderDelegate(
          itemBuilder,
          findChildIndexCallback: findChildIndexCallback,
          childCount: itemCount,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
        ));

  final SliverGridDelegate gridDelegate;

  @override
  RenderMyReordonableGrid createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element =
        context as SliverMultiBoxAdaptorElement;
    return RenderMyReordonableGrid(
      childManager: element,
      gridDelegate: gridDelegate,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderMyReordonableGrid renderObject) {
    renderObject.gridDelegate = gridDelegate;
  }
}

class RenderMyReordonableGrid extends RenderSliverGrid {
  RenderMyReordonableGrid({
    required super.childManager,
    required super.gridDelegate,
  });

  @override
  void performLayout() {
    childManager.didStartLayout();
    childManager.setDidUnderflow(false);

    final SliverGridLayout layout = gridDelegate.getLayout(constraints);

    if (firstChild == null) {
      addInitialChild();
    }

    RenderBox? child = firstChild;

    int index = 0;

    while (child != null) {
      final SliverGridGeometry gridGeometry =
          layout.getGeometryForChildIndex(index);

      final SliverGridParentData childParentData =
          child.parentData as SliverGridParentData;

      child.layout(
        constraints.asBoxConstraints(
            maxExtent: gridGeometry.mainAxisExtent,
            crossAxisExtent: gridGeometry.crossAxisExtent),
        parentUsesSize: true,
      );

      childParentData.layoutOffset = gridGeometry.scrollOffset;
      childParentData.crossAxisOffset = gridGeometry.crossAxisOffset;

      child = childAfter(child);

      child ??= insertAndLayoutChild(
          constraints.asBoxConstraints(
              maxExtent: gridGeometry.mainAxisExtent,
              crossAxisExtent: gridGeometry.crossAxisExtent),
          after: lastChild);

      index++;
    }
    double maxPaintExtent = layout.computeMaxScrollOffset(childCount);

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

      context.paintChild(child, childOffset);

      child = childAfter(child);
    }
  }
}
