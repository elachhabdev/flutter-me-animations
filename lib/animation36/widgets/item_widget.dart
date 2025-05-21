import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_me_animations/animation36/widgets/myreordonablelist_widget.dart';

class Item extends StatefulWidget {
  final int index;
  final Widget child;

  const Item({
    super.key,
    required this.index,
    required this.child,
  });

  @override
  State<Item> createState() => ItemState();
}

class ItemState extends State<Item> with SingleTickerProviderStateMixin {
  late MyReordonableListState listState;

  Offset positionStart = Offset.zero;

  Offset positionEnd = Offset.zero;

  AnimationController? positionAnimation;

  Key get key => widget.key!;

  int get index => widget.index;

  bool _dragging = false;

  bool get dragging => _dragging;

  int currentDirection = 0;

  late AnimationController animationController;

  set dragging(bool dragging) {
    if (mounted) {
      setState(() {
        _dragging = dragging;
      });
    }
  }

  Offset get position {
    if (positionAnimation != null) {
      final double animValue =
          Curves.easeInOut.transform(positionAnimation!.value);
      return Offset.lerp(positionStart, positionEnd, animValue)!;
    }
    return positionEnd;
  }

  Rect get targetInitialGeometry {
    final RenderBox itemRenderBox = context.findRenderObject()! as RenderBox;
    final Offset itemPosition = itemRenderBox.localToGlobal(Offset.zero);
    return itemPosition & itemRenderBox.size;
  }

  springBack() {
    animationController.animateWith(SpringSimulation(
        const SpringDescription(mass: 1, stiffness: 100, damping: 4.0),
        1.0,
        0.0,
        -0.1));
  }

  springStart() {
    animationController.animateWith(SpringSimulation(
        const SpringDescription(mass: 1, stiffness: 100, damping: 4.0),
        0.0,
        1.0,
        0.1));
  }

  springReset() {
    animationController.value = 0.0;
  }

  void updateForGap(
      int dragIndex, int swapIndex, double gapExtent, bool animate) {
    final Offset newPosition;

    if (swapIndex < dragIndex && index < dragIndex && index >= swapIndex) {
      newPosition = Offset(0.0, gapExtent);
    } else if (swapIndex > dragIndex &&
        index > dragIndex &&
        index <= swapIndex) {
      newPosition = Offset(0.0, -gapExtent);
    } else {
      newPosition = Offset.zero;
    }

    if (newPosition != positionEnd) {
      positionEnd = newPosition;
      if (animate) {
        if (positionAnimation == null) {
          positionAnimation = AnimationController(
            vsync: listState,
            duration: const Duration(milliseconds: 250),
          )
            ..addListener(rebuild)
            ..addStatusListener((AnimationStatus status) {
              if (status.isCompleted) {
                positionStart = positionEnd;
                positionAnimation!.dispose();
                positionAnimation = null;
              }
            })
            ..forward();
        } else {
          positionStart = position;
          positionAnimation!.forward(from: 0.0);
        }
      } else {
        if (positionAnimation != null) {
          positionAnimation!.dispose();
          positionAnimation = null;
        }
        positionStart = positionEnd;
      }
      rebuild();
    }
  }

  void resetGap() {
    if (positionAnimation != null) {
      positionAnimation!.dispose();
      positionAnimation = null;
    }
    positionStart = Offset.zero;
    positionEnd = Offset.zero;
    rebuild();
  }

  void rebuild() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    listState = MyReordonableListState.of(context);
    listState.registerItem(this);
    animationController = AnimationController.unbounded(vsync: this);
  }

  @override
  void didUpdateWidget(covariant Item oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      listState.unregisterItem(oldWidget.index, this);
      listState.registerItem(this);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    positionAnimation?.dispose();
    listState.unregisterItem(index, this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_dragging) {
      final Size size = listState.dragInfo!.itemSize;
      return SizedBox.fromSize(size: size);
    }
    listState.registerItem(this);

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Transform.rotate(
            angle: lerpDouble(0.0, -0.08, animationController.value)!,
            child: Transform(
                transform:
                    Matrix4.translationValues(position.dx, position.dy, 0.0),
                child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              blurRadius: lerpDouble(0.1, 8.0,
                                  animationController.value.clamp(0.0, 3.0))!,
                              spreadRadius: lerpDouble(0.1, 2.0,
                                  animationController.value.clamp(0.0, 3.0))!)
                        ]),
                    child: child)));
      },
      child: widget.child,
    );
  }
}
