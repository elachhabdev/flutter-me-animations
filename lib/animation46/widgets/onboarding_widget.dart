import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

class OnBoardingsWidget extends MultiChildRenderObjectWidget {
  final TickerProvider vsync;
  const OnBoardingsWidget(
      {super.key, required this.vsync, required super.children});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return OnBoardingsRender(vsync: vsync);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {}
}

class SliderParentData extends ContainerBoxParentData<RenderBox> {
  int index = 0;
}

class OnBoardingsRender extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, SliderParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, SliderParentData> {
  final PanGestureRecognizer _panGestureRecognizer = PanGestureRecognizer();

  final LayerHandle<TransformLayer> transformLayer =
      LayerHandle<TransformLayer>();

  final LayerHandle<ClipPathLayer> clipLayerLeft = LayerHandle<ClipPathLayer>();
  final LayerHandle<ClipPathLayer> clipLayerRight =
      LayerHandle<ClipPathLayer>();

  double animation = 0.0;

  late AnimationController animationControllerLeft;

  late AnimationController animationControllerRight;

  Path pathLeft = Path();

  Path pathRight = Path();

  Ticker? ticker;

  int currentIndex = 0;

  int prev = -1;

  int next = 1;

  double positionRightY = 0.0;

  double positionRightX = 0.0;

  double positionDelayedRightX = 0.0;

  double positionControlWidthRightX = 0.0;

  double positionControlHeightRightX = 0.0;

  double positionLeftY = 0.0;

  double positionLeftX = 0.0;

  double positionDelayedLeftX = 0.0;

  double positionControlWidthLeftX = 0.0;

  double positionControlHeightLeftX = 0.0;

  DateTime? panEndedTime;

  int currentPath = -1; //-1 no one 0 left 1 right

  bool isMovingLeft = false;

  List<Color> colors = [
    Colors.purple,
    Colors.orange,
    Colors.amber,
    Colors.pink
  ];

  updateAnimationLeft() {
    positionDelayedLeftX = lerpDouble(-50, 0.0, animationControllerLeft.value)!;
    positionControlWidthLeftX =
        lerpDouble(-50, 0.0, animationControllerLeft.value)!;
    positionControlHeightLeftX =
        lerpDouble(-50, 0.0, animationControllerLeft.value)!;

    markNeedsPaint();
  }

  updateAnimationRight() {
    positionDelayedRightX =
        lerpDouble(-50, 0.0, animationControllerRight.value)!;
    positionControlWidthRightX =
        lerpDouble(-50, 0.0, animationControllerRight.value)!;
    positionControlHeightRightX =
        lerpDouble(-50, 0.0, animationControllerRight.value)!;

    markNeedsPaint();
  }

  Duration lastTick = Duration.zero;

  startAnimation() {
    if (!ticker!.isActive) {
      ticker!.start();
    }
  }

  onTick(Duration elapsed) {
    final Duration deltaTime = elapsed - lastTick;

    final deltaTimeMS = deltaTime.inMilliseconds / 1000;

    lastTick = elapsed;

    if (isMovingLeft) {
      positionDelayedLeftX = lerpDouble(positionDelayedLeftX,
          positionControlWidthLeftX, 1 - exp(-12 * (deltaTimeMS)))!;

      positionControlWidthLeftX = lerpDouble(positionControlWidthLeftX,
          positionControlHeightLeftX, 1 - exp(-10 * (deltaTimeMS)))!;

      positionControlHeightLeftX = lerpDouble(positionControlHeightLeftX,
          positionLeftX, 1 - exp(-14 * (deltaTimeMS)))!;
    } else {
      positionDelayedRightX = lerpDouble(positionControlWidthRightX,
          positionControlWidthRightX, 1 - exp(-12 * (deltaTimeMS)))!;

      positionControlWidthRightX = lerpDouble(positionControlWidthRightX,
          positionControlHeightRightX, 1 - exp(-10 * (deltaTimeMS)))!;

      positionControlHeightRightX = lerpDouble(positionControlHeightRightX,
          positionRightX, 1 - exp(-14 * (deltaTimeMS)))!;
    }

    if (panEndedTime != null) {
      final now = DateTime.now();
      if (now.difference(panEndedTime!) > const Duration(milliseconds: 650)) {
        panEndedTime = null;
        lastTick = Duration.zero;

        if (!isMovingLeft) {
          if (next < childCount && positionRightX == constraints.maxWidth) {
            prev = currentIndex;
            currentIndex++;
            next++;

            positionRightX = 0;
            positionDelayedRightX = -50;
            positionControlWidthRightX = -50;
            positionControlHeightRightX = -50;
            currentPath = -1;
            isMovingLeft = false;
            positionRightY = constraints.maxHeight * 0.5;
            positionLeftY = constraints.maxHeight * 0.5;
            animationControllerLeft.value = 0.0;
            animationControllerRight.value = 0.0;

            animationControllerLeft.animateWith(SpringSimulation(
                const SpringDescription(mass: 1, stiffness: 100, damping: 5),
                0.0,
                1.0,
                0.01));
            animationControllerRight.animateWith(SpringSimulation(
                const SpringDescription(mass: 1, stiffness: 100, damping: 5),
                0.0,
                1.0,
                0.01));
          }
        } else {
          if (prev >= 0 && positionLeftX == constraints.maxWidth) {
            next = currentIndex;
            currentIndex--;
            prev--;

            positionLeftX = 0;
            positionDelayedLeftX = -50;
            positionControlWidthLeftX = -50;
            positionControlHeightLeftX = -50;
            currentPath = -1;
            isMovingLeft = false;
            positionRightY = constraints.maxHeight * 0.5;
            positionLeftY = constraints.maxHeight * 0.5;

            animationControllerLeft.value = 0.0;
            animationControllerRight.value = 0.0;

            animationControllerLeft.animateWith(SpringSimulation(
                const SpringDescription(mass: 1, stiffness: 100, damping: 5),
                0.0,
                1.0,
                0.01));
            animationControllerRight.animateWith(SpringSimulation(
                const SpringDescription(mass: 1, stiffness: 100, damping: 5),
                0.0,
                1.0,
                0.01));
          }
        }

        ticker!.stop();
      }
    }

    markNeedsPaint();
  }

  @override
  void dispose() {
    animationControllerRight.removeListener(updateAnimationRight);
    animationControllerRight.dispose();
    animationControllerLeft.removeListener(updateAnimationLeft);
    animationControllerLeft.dispose();
    ticker?.dispose();
    ticker = null;
    super.dispose();
  }

  OnBoardingsRender({required TickerProvider vsync}) {
    animationControllerLeft = AnimationController.unbounded(vsync: vsync)
      ..addListener(updateAnimationLeft);

    animationControllerRight = AnimationController.unbounded(vsync: vsync)
      ..addListener(updateAnimationRight);

    ticker = vsync.createTicker(onTick);

    _panGestureRecognizer
      ..onStart = (details) {
        panEndedTime = null;

        if (currentPath == 1) {
          if (pathRight.getBounds().contains(details.localPosition) &&
              next < childCount) {
            isMovingLeft = false;
            currentPath = 1;
          } else if (pathLeft.getBounds().contains(details.localPosition) &&
              prev >= 0) {
            isMovingLeft = true;
            currentPath = 0;
          }
        } else if (currentPath == 0) {
          if (pathLeft.getBounds().contains(details.localPosition) &&
              prev >= 0) {
            isMovingLeft = true;
            currentPath = 0;
          } else if (pathRight.getBounds().contains(details.localPosition) &&
              next < childCount) {
            isMovingLeft = false;
            currentPath = 1;
          }
        } else {
          if (pathRight.getBounds().contains(details.localPosition) &&
              next < childCount) {
            isMovingLeft = false;
            currentPath = 1;
          } else if (pathLeft.getBounds().contains(details.localPosition) &&
              prev >= 0) {
            isMovingLeft = true;
            currentPath = 0;
          }
        }

        if (isMovingLeft) {
          if (animationControllerLeft.isAnimating) {
            animationControllerLeft.stop();
          }
        } else {
          if (animationControllerRight.isAnimating) {
            animationControllerRight.stop();
          }
        }

        startAnimation();
      }
      ..onUpdate = (details) {
        panEndedTime = null;

        if (isMovingLeft) {
          if (prev >= 0) {
            positionLeftX =
                (positionLeftX + details.delta.dx).clamp(0, size.width);
            positionLeftY =
                (positionLeftY + details.delta.dy).clamp(0, size.height);
            markNeedsPaint();
          }
        } else {
          if (next < childCount) {
            positionRightX =
                (positionRightX - details.delta.dx).clamp(0, size.width);
            positionRightY =
                (positionRightY + details.delta.dy).clamp(0, size.height);
            markNeedsPaint();
          }
        }
      }
      ..onEnd = (details) {
        panEndedTime = DateTime.now();

        if (!isMovingLeft) {
          if (positionRightX >= size.width * 0.4) {
            positionRightX = size.width;
          } else {
            positionRightX = 0.0;
          }
        } else {
          if (positionLeftX >= size.width * 0.4) {
            positionLeftX = size.width;
          } else {
            positionLeftX = 0.0;
          }
        }
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
    final childrens = getChildrenAsList();

    positionRightY = constraints.maxHeight * 0.5;
    positionLeftY = constraints.maxHeight * 0.5;

    final childConstraints = constraints.loosen();

    for (int i = 0; i < childrens.length; i++) {
      final child = childrens[i];

      final SliderParentData childParentData =
          child.parentData as SliderParentData;

      childParentData.offset = Offset.zero;
      childParentData.index = i;

      child.layout(childConstraints, parentUsesSize: true);
    }
    size = Size(constraints.maxWidth, constraints.maxHeight);
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (pathLeft.contains(position) && prev >= 0) {
      result.add(BoxHitTestEntry(this, position));
      return true;
    } else if (pathRight.contains(position) && next < childCount) {
      result.add(BoxHitTestEntry(this, position));
      return true;
    } else {
      return false;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final childrens = getChildrenAsList();

    final child = childrens[currentIndex];
    final SliderParentData childParentData =
        child.parentData as SliderParentData;

    final canvas = context.canvas;

    final Paint paint = Paint()
      ..shader = RadialGradient(
          colors: [
            Color.lerp(colors[currentIndex], Colors.white, 0.4)!,
            colors[currentIndex]
          ],
          radius: 0.8,
          center: const Alignment(0.0, -0.5),
          focal: const Alignment(0.0, -0.5),
          stops: const [0.0, 1.0]).createShader(Offset.zero & size);

    canvas.drawRect(Offset.zero & size, paint);

    context.paintChild(child, childParentData.offset + offset);

    final double initialLeftX = lerpDouble(size.width * 0.07, size.width,
        (positionDelayedLeftX / (size.width)).clamp(-1.0, 1.0))!;

    final double controlWidthLeft = lerpDouble(size.height * 0.2,
        size.height * 0.5, (positionControlWidthLeftX / (size.width)))!;

    final double controlHeightLeft = lerpDouble(
        size.width * 0.07 + 50,
        size.width,
        (positionControlHeightLeftX / (size.width - 50)).clamp(-1.0, 1.0))!;

    final positionYwithControlLeft = controlWidthLeft * 0.5 + positionLeftY;

    final positionYwithNegativeControlLeft =
        -controlWidthLeft * 0.5 + positionLeftY;

    final heightwithControlLeft = size.height + controlWidthLeft;

    pathLeft = Path()
      ..moveTo(initialLeftX, -controlWidthLeft)
      ..lineTo(initialLeftX, positionLeftY - controlWidthLeft)
      ..cubicTo(
          initialLeftX,
          positionYwithNegativeControlLeft,
          controlHeightLeft,
          positionYwithNegativeControlLeft,
          controlHeightLeft,
          positionLeftY)
      ..cubicTo(
          controlHeightLeft,
          positionYwithControlLeft,
          initialLeftX,
          positionYwithControlLeft,
          initialLeftX,
          controlWidthLeft + positionLeftY)
      ..lineTo(initialLeftX, heightwithControlLeft)
      ..lineTo(0.0, heightwithControlLeft)
      ..lineTo(0.0, -controlWidthLeft);

    final double initialRightX = lerpDouble(size.width * 0.93, 0.0,
        (positionDelayedRightX / (size.width)).clamp(-1.0, 1.0))!;

    final double controlWidthRight = lerpDouble(size.height * 0.2,
        size.height * 0.5, (positionControlWidthRightX / (size.width)))!;

    final double controlHeightRight = lerpDouble(size.width * 0.93 - 50, 0,
        (positionControlHeightRightX / (size.width - 50)).clamp(-1.0, 1.0))!;

    final positionYwithControl = controlWidthRight * 0.5 + positionRightY;

    final positionYwithNegativeControl =
        -controlWidthRight * 0.5 + positionRightY;

    final heightwithControl = size.height + controlWidthRight;

    pathRight = Path()
      ..moveTo(initialRightX, -controlWidthRight)
      ..lineTo(initialRightX, positionRightY - controlWidthRight)
      ..cubicTo(initialRightX, positionYwithNegativeControl, controlHeightRight,
          positionYwithNegativeControl, controlHeightRight, positionRightY)
      ..cubicTo(
          controlHeightRight,
          positionYwithControl,
          initialRightX,
          positionYwithControl,
          initialRightX,
          controlWidthRight + positionRightY)
      ..lineTo(initialRightX, heightwithControl)
      ..lineTo(size.width, heightwithControl)
      ..lineTo(size.width, -controlWidthRight);
    if (isMovingLeft) {
      if (next < childrens.length) {
        clipLayerRight.layer = context.pushClipPath(
            needsCompositing, offset, Offset.zero & size, pathRight,
            (innercontext, offset) {
          final Paint paint = Paint()
            ..shader = RadialGradient(
                colors: [
                  Color.lerp(colors[next], Colors.white, 0.4)!,
                  colors[next]
                ],
                radius: 0.8,
                center: const Alignment(0.0, -0.5),
                focal: const Alignment(0.0, -0.5),
                stops: const [0.0, 1.0]).createShader(Offset.zero & size);

          innercontext.canvas.drawRect(Offset.zero & size, paint);
          innercontext.paintChild(
              childrens[next],
              Offset.lerp(
                      Offset(size.width, 0.0),
                      Offset.zero,
                      (positionDelayedRightX / (size.width))
                          .clamp(-1.0, 1.0))! +
                  offset);
        }, clipBehavior: Clip.hardEdge, oldLayer: clipLayerRight.layer);
      }
    } else {
      if (prev >= 0) {
        clipLayerLeft.layer = context.pushClipPath(
            needsCompositing, offset, Offset.zero & size, pathLeft,
            (innercontext, offset) {
          final Paint paint = Paint()
            ..shader = RadialGradient(
                colors: [
                  Color.lerp(colors[prev], Colors.white, 0.4)!,
                  colors[prev]
                ],
                radius: 0.8,
                center: const Alignment(0.0, -0.5),
                focal: const Alignment(0.0, -0.5),
                stops: const [0.0, 1.0]).createShader(Offset.zero & size);

          innercontext.canvas.drawRect(Offset.zero & size, paint);
          innercontext.paintChild(
              childrens[prev],
              Offset.lerp(Offset(-size.width, 0.0), Offset.zero,
                      (positionDelayedLeftX / (size.width)).clamp(-1.0, 1.0))! +
                  offset);
        }, clipBehavior: Clip.hardEdge, oldLayer: clipLayerLeft.layer);
      }
    }

    if (!isMovingLeft) {
      if (next < childrens.length) {
        clipLayerRight.layer = context.pushClipPath(
            needsCompositing, offset, Offset.zero & size, pathRight,
            (innercontext, offset) {
          final Paint paint = Paint()
            ..shader = RadialGradient(
                colors: [
                  Color.lerp(colors[next], Colors.white, 0.4)!,
                  colors[next]
                ],
                radius: 0.8,
                center: const Alignment(0.0, -0.5),
                focal: const Alignment(0.0, -0.5),
                stops: const [0.0, 1.0]).createShader(Offset.zero & size);

          innercontext.canvas.drawRect(Offset.zero & size, paint);
          innercontext.paintChild(
              childrens[next],
              Offset.lerp(
                      Offset(size.width, 0.0),
                      Offset.zero,
                      (positionDelayedRightX / (size.width))
                          .clamp(-1.0, 1.0))! +
                  offset);
        }, clipBehavior: Clip.hardEdge, oldLayer: clipLayerRight.layer);
      }
    } else {
      if (prev >= 0) {
        clipLayerLeft.layer = context.pushClipPath(
            needsCompositing, offset, Offset.zero & size, pathLeft,
            (innercontext, offset) {
          final Paint paint = Paint()
            ..shader = RadialGradient(
                colors: [
                  Color.lerp(colors[prev], Colors.white, 0.4)!,
                  colors[prev]
                ],
                radius: 0.8,
                center: const Alignment(0.0, -0.5),
                focal: const Alignment(0.0, -0.5),
                stops: const [0.0, 1.0]).createShader(Offset.zero & size);
          innercontext.canvas.drawRect(Offset.zero & size, paint);

          innercontext.paintChild(
              childrens[prev],
              Offset.lerp(Offset(-size.width, 0.0), Offset.zero,
                      (positionDelayedLeftX / (size.width)).clamp(-1.0, 1.0))! +
                  offset);
        }, clipBehavior: Clip.hardEdge, oldLayer: clipLayerLeft.layer);
      }
    }
  }
}
