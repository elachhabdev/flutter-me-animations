import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_me_animations/animation41/widgets/item_widget.dart';
import 'package:flutter_me_animations/animation41/widgets/myreordonablegrid_widget.dart';
import 'package:flutter_me_animations/animation41/widgets/overlay_content_widget.dart';

typedef DragItemUpdate = void Function(
    DragInfo item, Offset position, Offset delta);

typedef DragItemCallback = void Function(DragInfo item);

class DragInfo extends Drag {
  late MyReordonableGridState listState;
  late int index;
  late Widget child;
  late Offset dragPosition;
  late Offset dragOffset;
  late Size itemSize;
  late Size itemExtent;
  late Color color;

  ScrollableState? scrollable;
  AnimationController? springAnimation;
  AnimationController? dropAnimation;

  final DragItemUpdate? onUpdate;
  final DragItemCallback? onEnd;
  final DragItemCallback? onCancel;
  final VoidCallback? onDropCompleted;
  final TickerProvider tickerProvider;

  DragInfo({
    required ItemState item,
    Offset initialPosition = Offset.zero,
    this.onUpdate,
    this.onEnd,
    this.onCancel,
    this.onDropCompleted,
    required this.tickerProvider,
  }) {
    if (kFlutterMemoryAllocationsEnabled) {
      FlutterMemoryAllocations.instance.dispatchObjectCreated(
        library: 'package:flutter/widgets.dart',
        className: '$DragInfo',
        object: this,
      );
    }

    final RenderBox itemRenderBox =
        item.context.findRenderObject()! as RenderBox;

    color = item.color;
    listState = item.listState;
    index = item.index;
    child = item.widget.child;
    dragPosition = initialPosition;
    dragOffset = itemRenderBox.globalToLocal(initialPosition);
    itemSize = item.context.size!;
    itemExtent = itemSize;
    scrollable = Scrollable.of(item.context);
  }

  void dispose() {
    if (kFlutterMemoryAllocationsEnabled) {
      FlutterMemoryAllocations.instance.dispatchObjectDisposed(object: this);
    }
    dropAnimation?.dispose();
    springAnimation?.dispose();
  }

  void startDrag() {
    springAnimation = AnimationController.unbounded(
      vsync: tickerProvider,
    )..animateWith(SpringSimulation(
        const SpringDescription(mass: 1, stiffness: 100, damping: 4.0),
        0.0,
        1.0,
        0.01));

    dropAnimation = AnimationController(
        vsync: tickerProvider, duration: const Duration(milliseconds: 250))
      ..addStatusListener((AnimationStatus status) {
        if (status.isDismissed) {
          dropCompleted();
        }
      })
      ..forward();
  }

  @override
  void update(DragUpdateDetails details) {
    final Offset delta = Offset(details.delta.dx, details.delta.dy);
    dragPosition += delta;
    onUpdate?.call(this, dragPosition, details.delta);
  }

  @override
  void end(DragEndDetails details) {
    dropAnimation!.reverse();
    onEnd?.call(this);
  }

  @override
  void cancel() {
    springAnimation?.dispose();
    springAnimation = null;
    dropAnimation?.dispose();
    dropAnimation = null;
    onCancel?.call(this);
  }

  void dropCompleted() {
    springAnimation?.dispose();
    springAnimation = null;
    dropAnimation?.dispose();
    dropAnimation = null;
    onDropCompleted?.call();
  }

  Widget createOverlay(BuildContext context) {
    return OverlayContentWidget(
      listState: listState,
      index: index,
      size: itemSize,
      springAnimation: springAnimation!,
      position: dragPosition - dragOffset - overlayOriginBox(context),
      dropAnimation: dropAnimation!,
      color: color,
      child: child,
    );
  }
}

Offset overlayOriginBox(BuildContext context) {
  final OverlayState overlay =
      Overlay.of(context, debugRequiredFor: context.widget);
  final RenderBox overlayBox = overlay.context.findRenderObject()! as RenderBox;
  return overlayBox.localToGlobal(Offset.zero);
}
