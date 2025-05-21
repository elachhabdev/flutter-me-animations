import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

//add delayed multi Drag Gesture to add scroll and offset unattempted to go down when attemptedcontainer grow

class DraggableMainWidget extends MultiChildRenderObjectWidget {
  final TickerProvider vsync;
  final double spacing;
  final Function onPanEnd;
  final Function onPanStart;
  final int totalWords;
  final double padding;
  const DraggableMainWidget({
    super.key,
    required super.children,
    required this.vsync,
    required this.spacing,
    required this.onPanEnd,
    required this.onPanStart,
    required this.totalWords,
    required this.padding,
  });
  @override
  RenderObject createRenderObject(BuildContext context) {
    return DraggableMultiChildRenderObject(
      vsync: vsync,
      onPanEnd: onPanEnd,
      onPanStart: onPanStart,
      totalCount: totalWords,
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
  bool isAttempted = false;
  Offset originOffset = Offset.zero;
  bool flying = false;
  int index = 0;
  Color currentColor = const Color(0xFF1E2721);
  Color targetColor = const Color(0xFF1E2721);
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

  late List<int> unAttemptedIndexs;

  List<int> attemptedIndexs = [];

  TickerProvider get vsync => _vsync;

  late final Function _onPanStart;

  late final Function _onPanEnd;

  late Ticker ticker;

  late TickerProvider _vsync;

  double attemptedHeight = 0.0;

  double unattemptedHeight = 0.0;

  double? heightofchild;

  double animationColor = 0.0;

  Offset? attemptedContainerOffset;

  Offset? unAttemptedContainerOffset;

  bool layoutPlaceHolder = false;

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

  late final AnimationController animationController;

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

  void updateColor() {
    animationColor = animationController.value;
    markNeedsPaint();
  }

  void endCurrentDragging() {
    if (dragChild != null) {
      final DragParentData parentData = dragChild!.parentData as DragParentData;

      prevDragChild = dragChild;

      final DragParentData prevParentData =
          prevDragChild!.parentData as DragParentData;

      parentData.currentColor = parentData.targetColor;
      parentData.targetColor = parentData.isAttempted
          ? const Color(0xFF84CC16)
          : const Color(0xFF1E2721);

      prevParentData.currentColor = parentData.currentColor;
      prevParentData.targetColor = prevParentData.isAttempted
          ? const Color(0xFF84CC16)
          : const Color(0xFF1E2721);

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
    animationController.removeListener(updateColor);
    animationController.dispose();
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

  DraggableMultiChildRenderObject({
    required TickerProvider vsync,
    required onPanEnd,
    required onPanStart,
    required totalCount,
  }) {
    _vsync = vsync;
    _onPanEnd = onPanEnd;
    _onPanStart = onPanStart;

    unAttemptedIndexs =
        List.generate(totalCount, (index) => index, growable: true);

    ticker = vsync.createTicker(onTick);

    animationController2 = AnimationController.unbounded(vsync: vsync)
      ..addListener(updateScale);

    animationController = AnimationController(
        vsync: vsync, duration: const Duration(milliseconds: 250))
      ..addListener(updateColor);

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
          parentData.targetColor = const Color(0xFF8B5CF6);
          prevDragChild = null;

          animationController.forward();

          _onPanStart(dragIndex);

          markNeedsLayout();
        }
      }
      ..onUpdate = (details) {
        lastMouvementTime = DateTime.now();

        if (dragChild != null) {
          final DragParentData draggingParentData =
              dragChild!.parentData as DragParentData;

          draggingParentData.dragOffset += details.delta;

          final dragCenter = dragChild!.size.center(
              draggingParentData.initialDraggingOffset +
                  draggingParentData.dragOffset);

          final Rect geometryAttempted = attemptedContainerOffset! &
              Size(constraints.maxWidth - 3 * spacing, attemptedHeight);

          final Rect geometryUnAttempted = unAttemptedContainerOffset! &
              Size(constraints.maxWidth - 3 * spacing, unattemptedHeight);

          //is inside Attempted

          if (geometryAttempted.contains(dragCenter)) {
            if (!attemptedIndexs.contains(dragIndex!)) {
              unAttemptedIndexs.remove(dragIndex!);
              attemptedIndexs.add(dragIndex!);
              draggingParentData.isAttempted = true;
              draggingParentData.currentColor = draggingParentData.targetColor;
              draggingParentData.targetColor = const Color(0xFF84CC16);
              animationController.reset();
              animationController.forward();
            }

            int newIndex = swapIndex!;

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

              int indexOfDrag = attemptedIndexs.indexOf(dragIndex!);
              int indexOfSwap = attemptedIndexs.indexOf(swapIndex!);

              int temp = attemptedIndexs[indexOfDrag];
              attemptedIndexs[indexOfDrag] = attemptedIndexs[indexOfSwap];
              attemptedIndexs[indexOfSwap] = temp;

              startAnimation();
            }
            markNeedsPaint();
          } else if (geometryUnAttempted.contains(dragCenter)) {
            if (!unAttemptedIndexs.contains(dragIndex!)) {
              attemptedIndexs.remove(dragIndex!);
              unAttemptedIndexs.add(dragIndex!);
              draggingParentData.isAttempted = false;
              draggingParentData.currentColor = draggingParentData.targetColor;
              draggingParentData.targetColor = const Color(0xFF8B5CF6);
              animationController.reset();
              animationController.forward();
            }
          }
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

          animationController.reset();
          animationController.forward();

          _onPanEnd(attemptedIndexs);

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
    double leftAttempted = 3 * spacing;

    double topAttempted = 0.0;

    double leftUnAttempted = 3 * spacing;

    double topUnAttempted = 0.0;

    //calculate constraints

    final containerHeight =
        (constraints.maxHeight - 4 * spacing) * 0.5 + spacing;

    unattemptedHeight = containerHeight;

    attemptedContainerOffset = Offset((3 / 2) * spacing, -spacing);

    final childrens = getChildrenAsList();

    if (unAttemptedContainerOffset == null) {
      for (int i = 0; i < childrens.length; i++) {
        final child = childrens[i];

        child.layout(const BoxConstraints(), parentUsesSize: true);

        final maxWidth = constraints.maxWidth - 2 * spacing;

        if (leftUnAttempted + child.size.width + spacing > maxWidth) {
          leftUnAttempted = 3 * spacing;
          topUnAttempted++;
        }

        leftUnAttempted += child.size.width + spacing;
      }

      unAttemptedContainerOffset =
          Offset((3 / 2) * spacing, unattemptedHeight + 2 * spacing);

      //to fill container (topUnAttempted +1) to add some space + 1

      heightofchild = (containerHeight / (topUnAttempted + 2)) - spacing;
    }

    final BoxConstraints childConstraints =
        BoxConstraints.tightFor(height: heightofchild);

    if (dragChild != null) {
      dragChild!.layout(childConstraints, parentUsesSize: true);
    }

//layout placeholder

    if (!layoutPlaceHolder) {
      double topPlaceholder = 0.0;
      double leftPlaceholder = 3 * spacing;

      for (int i = 0; i < childrens.length; i++) {
        final child = childrens[i];

        final DragParentData childParentData =
            child.parentData as DragParentData;

        child.layout(childConstraints, parentUsesSize: true);

        final maxWidth = constraints.maxWidth - 2 * spacing;

        if (leftPlaceholder + child.size.width + spacing > maxWidth) {
          leftPlaceholder = 3 * spacing;
          topPlaceholder++;
        }

        final topWithOffset = topPlaceholder * (child.size.height + spacing) +
            unAttemptedContainerOffset!.dy;

        childParentData.originOffset = Offset(leftPlaceholder, topWithOffset);

        childParentData.initialDraggingOffset =
            Offset(leftPlaceholder, topWithOffset);

        childParentData.currentOffset = Offset(leftPlaceholder, topWithOffset);

        leftPlaceholder += child.size.width + spacing;
      }

      layoutPlaceHolder = true;
    }

    if (dragChild == null || isAnimating) {
      //layout unAttempteds

      leftUnAttempted = 3 * spacing;

      topUnAttempted = 0.0;

      for (int i = 0; i < unAttemptedIndexs.length; i++) {
        final child = childrens[unAttemptedIndexs[i]];

        final DragParentData childParentData =
            child.parentData as DragParentData;

        child.layout(childConstraints, parentUsesSize: true);

        if (dragIndex == null || dragIndex != unAttemptedIndexs[i]) {
          if (isAnimating) {
            childParentData.offset = Offset.lerp(childParentData.offset,
                childParentData.originOffset, animationProgress)!;
          } else {
            childParentData.offset = childParentData.originOffset;
          }
          childParentData.initialDraggingOffset = childParentData.originOffset;
        }

        childParentData.currentOffset = childParentData.originOffset;

        childParentData.index = unAttemptedIndexs[i];
      }

      //layout Attempteds

      for (int i = 0; i < attemptedIndexs.length; i++) {
        final child = childrens[attemptedIndexs[i]];

        final DragParentData childParentData =
            child.parentData as DragParentData;

        child.layout(childConstraints, parentUsesSize: true);

        final maxWidth = constraints.maxWidth - 2 * spacing;

        if (leftAttempted + child.size.width + spacing > maxWidth) {
          leftAttempted = 3 * spacing;
          topAttempted++;
        }

        final shouldRepositioned = childParentData.offset !=
            Offset(leftAttempted, topAttempted * (child.size.height + spacing));

        if (shouldRepositioned) {
          if (dragIndex == null || dragIndex != attemptedIndexs[i]) {
            if (isAnimating) {
              childParentData.offset = Offset.lerp(
                  childParentData.offset,
                  Offset(leftAttempted,
                      topAttempted * (child.size.height + spacing)),
                  animationProgress)!;

              if (childParentData.offset.dy !=
                  topAttempted * (child.size.height + spacing)) {
                childParentData.flying = true;
              }
            } else {
              childParentData.offset = Offset(
                  leftAttempted, topAttempted * (child.size.height + spacing));

              childParentData.flying = false;
            }

            childParentData.initialDraggingOffset = Offset(
                leftAttempted, topAttempted * (child.size.height + spacing));
          }

          childParentData.currentOffset = Offset(
              leftAttempted, topAttempted * (child.size.height + spacing));

          markNeedsPaint();
        }

        leftAttempted += child.size.width + spacing;

        attemptedHeight = (topAttempted + 1) * (child.size.height + spacing);

        childParentData.index = attemptedIndexs[i];
      }

      attemptedHeight = max(attemptedHeight, unattemptedHeight);

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

    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF84CC16);

    final paintContainer = Paint()
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill
      ..color = Colors.white30;

    final paintbg = Paint()
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF33453E);

    final childrens = getChildrenAsList();

    for (int i = 0; i < childrens.length; i++) {
      final child = childrens[i];

      final DragParentData childParentData = child.parentData as DragParentData;

      final childOffset = offset + childParentData.originOffset;

      canvas.drawRRect(
          RRect.fromRectAndRadius(
              childOffset + const Offset(2, 2) &
                  Size(child.size.width - 4, child.size.height - 4),
              const Radius.circular(15)),
          paintContainer);
    }
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            attemptedContainerOffset! &
                Size(constraints.maxWidth - 3 * spacing,
                    attemptedHeight + spacing),
            const Radius.circular(30)),
        paintbg);

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            attemptedContainerOffset! &
                Size(constraints.maxWidth - 3 * spacing,
                    attemptedHeight + spacing),
            const Radius.circular(30)),
        paint);

    if (dragChild == null && prevDragChild == null) {
      while (child != null) {
        final DragParentData childParentData =
            child.parentData as DragParentData;
        final childOffset = offset + childParentData.offset;

        final paintBgContainer = Paint()
          ..color = childParentData.isAttempted
              ? const Color(0xFF84CC16)
              : const Color(0xFF1E2721);

        context.canvas.drawRRect(
            RRect.fromRectAndRadius(
                childOffset & child.size, const Radius.circular(15)),
            paintBgContainer);
        context.paintChild(child, childOffset);
        child = childAfter(child);
      }
    } else {
      final childrens = getChildrenAsList();

      final paintBgContainer = Paint()..color = const Color(0xFF1E2721);

      for (int i = 0; i < unAttemptedIndexs.length; i++) {
        final child = childrens[unAttemptedIndexs[i]];
        final DragParentData childParentData =
            child.parentData as DragParentData;
        final childOffset = offset + childParentData.offset;
        if (childParentData.index != dragIndex && child != prevDragChild) {
          context.canvas.drawRRect(
              RRect.fromRectAndRadius(
                  childOffset & child.size, const Radius.circular(15)),
              paintBgContainer);
          context.paintChild(child, childOffset);
        }
      }

      final paintBgAttemptedContainer = Paint()
        ..color = const Color(0xFF84CC16);

      for (int i = 0; i < attemptedIndexs.length; i++) {
        final child = childrens[attemptedIndexs[i]];
        final DragParentData childParentData =
            child.parentData as DragParentData;
        if (!childParentData.flying) {
          final childOffset = offset + childParentData.offset;
          if (childParentData.index != dragIndex && child != prevDragChild) {
            context.canvas.drawRRect(
                RRect.fromRectAndRadius(
                    childOffset & child.size, const Radius.circular(15)),
                paintBgAttemptedContainer);
            context.paintChild(child, childOffset);
          }
        }
      }

      for (int i = 0; i < attemptedIndexs.length; i++) {
        final child = childrens[attemptedIndexs[i]];
        final DragParentData childParentData =
            child.parentData as DragParentData;
        if (childParentData.flying) {
          final childOffset = offset + childParentData.offset;
          if (childParentData.index != dragIndex && child != prevDragChild) {
            context.canvas.drawRRect(
                RRect.fromRectAndRadius(
                    childOffset & child.size, const Radius.circular(15)),
                paintBgAttemptedContainer);
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

        final Paint paintDrag = Paint()
          ..color = Color.lerp(childParentData.currentColor,
              childParentData.targetColor, animationColor)!;

        transformLayer.layer = context.pushTransform(
            needsCompositing,
            childOffset,
            Matrix4.identity()
              ..translate(translateCenter.dx, translateCenter.dy)
              ..scale(lerpDouble(1.0, 1.1, animationScale))
              ..translate(-translateCenter.dx, -translateCenter.dy),
            (innerContext, offset) {
          innerContext.canvas.drawRRect(
              RRect.fromRectAndRadius(
                  childOffset & dragChild!.size, const Radius.circular(15)),
              paintDrag);
          innerContext.paintChild(dragChild!, childOffset);
        }, oldLayer: transformLayer.layer);
      } else if (prevDragChild != null) {
        final DragParentData childParentData =
            prevDragChild!.parentData as DragParentData;

        final childOffset = offset + childParentData.offset;

        final translateCenter = Alignment.center.alongSize(prevDragChild!.size);

        final Paint paintDrag = Paint()
          ..color = Color.lerp(childParentData.currentColor,
              childParentData.targetColor, animationColor)!;

        transformLayer.layer = context.pushTransform(
            needsCompositing,
            childOffset,
            Matrix4.identity()
              ..translate(translateCenter.dx, translateCenter.dy)
              ..scale(lerpDouble(1.0, 1.1, animationScale))
              ..translate(-translateCenter.dx, -translateCenter.dy),
            (innerContext, offset) {
          innerContext.canvas.drawRRect(
              RRect.fromRectAndRadius(
                  childOffset & prevDragChild!.size, const Radius.circular(15)),
              paintDrag);
          innerContext.paintChild(prevDragChild!, childOffset);
        }, oldLayer: transformLayer.layer);
      }
    }
  }
}
