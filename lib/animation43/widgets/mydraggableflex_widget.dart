import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

class MydraggableFlexWidget extends MultiChildRenderObjectWidget {
  final TickerProvider vsync;
  final double spacing;
  final Function onPanEnd;
  final Function onPanStart;
  final int totalTask;

  const MydraggableFlexWidget({
    super.key,
    required super.children,
    required this.vsync,
    required this.spacing,
    required this.onPanEnd,
    required this.onPanStart,
    required this.totalTask,
  });
  @override
  RenderObject createRenderObject(BuildContext context) {
    return DraggableMultiChildRenderObject(
      vsync: vsync,
      onPanEnd: onPanEnd,
      onPanStart: onPanStart,
      totalCount: totalTask,
    );
  }

  @override
  void updateRenderObject(BuildContext context,
      covariant DraggableMultiChildRenderObject renderObject) {
    renderObject
      ..vsync = vsync
      ..spacing = spacing;
  }
}

class DragParentData extends ContainerBoxParentData<RenderBox> {
  bool isDragging = false;
  Offset dragOffset = Offset.zero;
  Offset currentOffset = Offset.zero;
  Offset initialDraggingOffset = Offset.zero;
  bool flying = false;
  int index = 0;
}

class DraggableMultiChildRenderObject extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, DragParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, DragParentData> {
  final PanGestureRecognizer _panGestureRecognizer = PanGestureRecognizer();
  RenderBox? dragChild;
  RenderBox? prevDragChild;
  int? dragIndex;
  int? swapIndex;
  bool isAnimating = false;
  double animationProgress = 0.0;
  double animationScale = 0.0;

  final LayerHandle<TransformLayer> transformLayer =
      LayerHandle<TransformLayer>();

  late List<int> currentIndexes;

  TickerProvider get vsync => _vsync;

  late final Function _onPanStart;

  late final Function _onPanEnd;

  late Ticker ticker;

  late TickerProvider _vsync;

  set vsync(TickerProvider value) {
    if (value == _vsync) {
      return;
    }
    _vsync = value;
    animationController2.resync(vsync);
  }

  double _spacing = 10.0;

  double get spacing => _spacing;

  set spacing(double value) {
    if (value == _spacing) {
      return;
    }
    _spacing = value;
    markNeedsLayout();
  }

  late final AnimationController animationController2;

  DateTime? lastMouvementTime;

  Duration lastTick = Duration.zero;

  final decayFactor = 10;

  void startAnimation() {
    isAnimating = true;

    if (ticker.isActive) {
      return;
    }

    ticker.start();
  }

  void updateScale() {
    animationScale = animationController2.value;
    markNeedsPaint();
  }

  void endCurrentDragging() {
    if (dragChild != null) {
      final DragParentData parentData = dragChild!.parentData as DragParentData;
      prevDragChild = dragChild;
      parentData.dragOffset = Offset.zero;
      parentData.isDragging = false;
      dragChild = null;
      dragIndex = null;
    }
  }

  void onTick(Duration elapsed) {
    final Duration deltaTime = elapsed - lastTick;

    final deltaTimeMS = deltaTime.inMilliseconds / 1000;

    lastTick = elapsed;

    animationProgress = 1 - exp(-decayFactor * (deltaTimeMS));

    if (lastMouvementTime != null) {
      final now = DateTime.now();
      if (now.difference(lastMouvementTime!) > const Duration(seconds: 3)) {
        isAnimating = false;
        lastMouvementTime = null;
        lastTick = Duration.zero;
        markNeedsLayout();
        ticker.stop();
      }
    }

    markNeedsLayout();
  }

  @override
  void dispose() {
    animationController2.removeListener(updateScale);
    animationController2.dispose();
    ticker.dispose();
    super.dispose();
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void detach() {
    _panGestureRecognizer.dispose();
    super.detach();
  }

  DraggableMultiChildRenderObject(
      {required TickerProvider vsync,
      required onPanEnd,
      required onPanStart,
      required totalCount}) {
    _vsync = vsync;
    _onPanEnd = onPanEnd;
    _onPanStart = onPanStart;

    currentIndexes =
        List.generate(totalCount, (index) => index, growable: true);

    ticker = vsync.createTicker(onTick);

    animationController2 = AnimationController.unbounded(vsync: vsync)
      ..addListener(updateScale);

    _panGestureRecognizer
      ..onStart = (details) {
        final RenderBox? targetChild = _hitTestChild(details.localPosition);

        lastMouvementTime = DateTime.now();

        dragChild = targetChild;

        if (dragChild != null) {
          animationController2.animateWith(SpringSimulation(
              const SpringDescription(mass: 1, stiffness: 100, damping: 4),
              animationController2.value,
              1,
              0.1));

          final DragParentData parentData =
              dragChild!.parentData as DragParentData;
          parentData.isDragging = true;
          dragIndex = parentData.index;
          swapIndex = parentData.index;
          prevDragChild = null;

          _onPanStart(dragIndex);

          markNeedsLayout();
        }
      }
      ..onUpdate = (details) {
        lastMouvementTime = DateTime.now();

        if (dragChild != null) {
          int newIndex = swapIndex!;

          final DragParentData draggingParentData =
              dragChild!.parentData as DragParentData;

          draggingParentData.dragOffset += details.delta;

          final dragCenter = dragChild!.size.center(
              draggingParentData.initialDraggingOffset +
                  draggingParentData.dragOffset);

          for (RenderBox child in getChildrenAsList()) {
            final DragParentData parentData =
                child.parentData as DragParentData;

            final Rect geometry = parentData.currentOffset & child.size;

            if (geometry.contains(dragCenter)) {
              newIndex = parentData.index;
              break;
            }
          }
          if (newIndex != swapIndex) {
            swapIndex = newIndex;

            int indexOfDrag = currentIndexes.indexOf(dragIndex!);
            int indexOfSwap = currentIndexes.indexOf(swapIndex!);

            int temp = currentIndexes[indexOfDrag];
            currentIndexes[indexOfDrag] = currentIndexes[indexOfSwap];
            currentIndexes[indexOfSwap] = temp;

            startAnimation();
          }
          markNeedsPaint();
        }
      }
      ..onEnd = (details) {
        lastMouvementTime = DateTime.now();

        if (dragChild != null) {
          final DragParentData parentData =
              dragChild!.parentData as DragParentData;

          parentData.offset =
              parentData.dragOffset + parentData.initialDraggingOffset;

          animationController2.animateWith(SpringSimulation(
              const SpringDescription(mass: 1, stiffness: 100, damping: 4),
              1,
              0,
              -0.1));

          endCurrentDragging();

          _onPanEnd();

          startAnimation();
        }
      };
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! DragParentData) {
      child.parentData = DragParentData();
    }
  }

  @override
  void performLayout() {
    double left = spacing;
    double top = 0.0;

    final BoxConstraints childConstraints = constraints.loosen();

    if (dragChild != null) {
      dragChild!.layout(childConstraints, parentUsesSize: true);
    }

    if (dragChild == null || isAnimating) {
      final childrens = getChildrenAsList();

      for (int i = 0; i < currentIndexes.length; i++) {
        final child = childrens[currentIndexes[i]];

        final DragParentData childParentData =
            child.parentData as DragParentData;

        child.layout(childConstraints, parentUsesSize: true);

        if (left + child.size.width + spacing > constraints.maxWidth) {
          left = spacing;
          top++;
        }

        final shouldRepositioned = childParentData.offset !=
            Offset(left, top * (child.size.height + spacing));

        if (shouldRepositioned) {
          if (dragIndex == null || dragIndex != currentIndexes[i]) {
            if (isAnimating) {
              childParentData.offset = Offset.lerp(
                  childParentData.offset,
                  Offset(left, top * (child.size.height + spacing)),
                  animationProgress)!;

              if (childParentData.offset.dy !=
                  top * (child.size.height + spacing)) {
                childParentData.flying = true;
              }
            } else {
              childParentData.offset =
                  Offset(left, top * (child.size.height + spacing));

              childParentData.flying = false;
            }

            childParentData.initialDraggingOffset =
                Offset(left, top * (child.size.height + spacing));
          }

          childParentData.currentOffset =
              Offset(left, top * (child.size.height + spacing));

          markNeedsPaint();
        }

        left += child.size.width + spacing;

        childParentData.index = currentIndexes[i];
      }

      size = constraints
          .constrain(Size(constraints.maxWidth, constraints.maxHeight));
    }
  }

  RenderBox? _hitTestChild(Offset position) {
    RenderBox? child = lastChild;
    while (child != null) {
      final DragParentData childParentData = child.parentData as DragParentData;
      final Rect childBounds = Rect.fromLTWH(
        childParentData.offset.dx,
        childParentData.offset.dy,
        child.size.width,
        child.size.height,
      );

      if (childBounds.contains(position)) {
        return child;
      }
      child = childBefore(child);
    }
    return null;
  }

  @override
  bool hitTestSelf(Offset position) {
    return true;
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      _panGestureRecognizer.addPointer(event);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;

    if (dragChild == null && prevDragChild == null) {
      while (child != null) {
        final DragParentData childParentData =
            child.parentData as DragParentData;
        final childOffset = offset + childParentData.offset;

        context.paintChild(child, childOffset);
        child = childAfter(child);
      }
    } else {
      final childrens = getChildrenAsList();

      for (int i = 0; i < childrens.length; i++) {
        final child = childrens[currentIndexes[i]];
        final DragParentData childParentData =
            child.parentData as DragParentData;
        if (!childParentData.flying) {
          final childOffset = offset + childParentData.offset;
          if (childParentData.index != dragIndex && child != prevDragChild) {
            context.paintChild(child, childOffset);
          }
        }
      }

      for (int i = 0; i < childrens.length; i++) {
        final child = childrens[currentIndexes[i]];
        final DragParentData childParentData =
            child.parentData as DragParentData;
        if (childParentData.flying) {
          final childOffset = offset + childParentData.offset;
          if (childParentData.index != dragIndex && child != prevDragChild) {
            context.paintChild(child, childOffset);
          }
        }
      }

      if (dragChild != null) {
        final DragParentData childParentData =
            dragChild!.parentData as DragParentData;
        final childOffset = offset +
            childParentData.dragOffset +
            childParentData.initialDraggingOffset;

        final translateCenter = Alignment.center.alongSize(dragChild!.size);

        transformLayer.layer = context.pushTransform(
            needsCompositing,
            childOffset,
            Matrix4.identity()
              ..translate(translateCenter.dx, translateCenter.dy)
              ..scale(lerpDouble(1.0, 1.1, animationScale))
              ..translate(-translateCenter.dx, -translateCenter.dy),
            (context, offset) => context.paintChild(dragChild!, childOffset),
            oldLayer: transformLayer.layer);
      } else if (prevDragChild != null) {
        final DragParentData childParentData =
            prevDragChild!.parentData as DragParentData;

        final childOffset = offset + childParentData.offset;

        final translateCenter = Alignment.center.alongSize(prevDragChild!.size);

        transformLayer.layer = context.pushTransform(
            needsCompositing,
            childOffset,
            Matrix4.identity()
              ..translate(translateCenter.dx, translateCenter.dy)
              ..scale(lerpDouble(1.0, 1.1, animationScale))
              ..translate(-translateCenter.dx, -translateCenter.dy),
            (context, offset) =>
                context.paintChild(prevDragChild!, childOffset),
            oldLayer: transformLayer.layer);
      }
    }
  }
}
