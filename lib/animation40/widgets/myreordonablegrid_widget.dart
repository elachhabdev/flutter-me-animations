import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation40/widgets/delayed_drag_widget.dart';
import 'package:flutter_me_animations/animation40/widgets/drag_gesture_info.dart';
import 'package:flutter_me_animations/animation40/widgets/item_content_widget.dart';
import 'package:flutter_me_animations/animation40/widgets/item_widget.dart';
import 'package:flutter_me_animations/animation40/widgets/myreodonablesliver.dart';
import 'package:flutter_me_animations/models/reordonable.dart';

class MyReordonableGrid extends StatefulWidget {
  final List<Reordonable> items;
  final Function reorder;
  const MyReordonableGrid(
      {super.key, required this.items, required this.reorder});

  @override
  State<MyReordonableGrid> createState() => MyReordonableGridState();
}

class MyReordonableGridState extends State<MyReordonableGrid>
    with TickerProviderStateMixin {
  static MyReordonableGridState of(BuildContext context) {
    final MyReordonableGridState? result =
        context.findAncestorStateOfType<MyReordonableGridState>();
    assert(() {
      if (result == null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
            'MyReordonableGrid.of() called with a context that does not contain a MyReordonableGrid.',
          ),
          context.describeElement('The context used was'),
        ]);
      }
      return true;
    }());
    return result!;
  }

  static MyReordonableGridState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<MyReordonableGridState>();
  }

  final Map<int, ItemState> itemStates = <int, ItemState>{};

  List<int> currentIndexes =
      List.generate(20, (index) => index, growable: true);

  OverlayEntry? overlayEntry;

  OverlayEntry? overlayEntryBackground;

  int? dragIndex;

  DragInfo? dragInfo;

  int? swapIndex;

  Offset? finalDropPosition;

  MultiDragGestureRecognizer? _recognizer;

  int? recognizerPointer;

  EdgeDraggingAutoScroller? autoScroller;

  late ScrollableState scrollable;

  Offset? currentPosition;

  double bgPercent = 0.0;

  late AnimationController animationController;

  Rect get dragTargetRect {
    final Offset origin = dragInfo!.dragPosition - dragInfo!.dragOffset;
    return Rect.fromLTWH(origin.dx, origin.dy, dragInfo!.itemSize.width,
        dragInfo!.itemSize.height);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scrollable = Scrollable.of(context);
    if (autoScroller?.scrollable != scrollable) {
      autoScroller?.stopAutoScroll();
      autoScroller = EdgeDraggingAutoScroller(
        scrollable,
        onScrollViewScrolled: handleScrollableAutoScrolled,
        velocityScalar: 50,
      );
    }
  }

  @override
  void dispose() {
    dragReset();
    _recognizer?.dispose();
    animationController.removeListener(updateBgOverlay);
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    animationController.addListener(updateBgOverlay);
  }

  void startItemDragReorder({
    required int index,
    required PointerDownEvent event,
    required MultiDragGestureRecognizer recognizer,
  }) {
    assert(0 <= index && index < widget.items.length);
    setState(() {
      if (dragInfo != null) {
        cancelReorder();
      } else if (_recognizer != null && recognizerPointer != event.pointer) {
        _recognizer!.dispose();
        _recognizer = null;
        recognizerPointer = null;
      }

      if (itemStates.containsKey(index)) {
        dragIndex = index;
        _recognizer = recognizer
          ..onStart = dragStart
          ..addPointer(event);
        recognizerPointer = event.pointer;
      } else {
        throw Exception('Attempting to start a drag on a non-visible item');
      }
    });
  }

  void cancelReorder() {
    setState(() {
      dragReset();
    });
  }

  void registerItem(ItemState item) {
    itemStates[item.index] = item;
    if (item.index == dragInfo?.index) {
      item.dragging = true;
      item.rebuild();
    }
  }

  void unregisterItem(int index, ItemState item) {
    final ItemState? currentItem = itemStates[index];
    if (currentItem == item) {
      itemStates.remove(index);
    }
  }

  updateBgOverlay() {
    bgPercent = animationController.value;
    overlayEntryBackground?.markNeedsBuild();
  }

  Drag? dragStart(Offset position) {
    assert(dragInfo == null);

    if (itemStates.values.any((e) => e.dragging)) return null;

    final ItemState item = itemStates[dragIndex!]!;
    item.dragging = true;
    item.rebuild();
    item.springStart();

    swapIndex = item.index;

    dragInfo = DragInfo(
      item: item,
      initialPosition: position,
      onUpdate: dragUpdate,
      onCancel: dragCancel,
      onEnd: dragEnd,
      onDropCompleted: dropCompleted,
      tickerProvider: this,
    );

    dragInfo!.startDrag();

    final OverlayState overlay = Overlay.of(context);

    assert(overlayEntry == null && overlayEntryBackground == null);

    overlayEntry = OverlayEntry(builder: dragInfo!.createOverlay);

    overlayEntryBackground = OverlayEntry(
      builder: (context) {
        final Size size = MediaQuery.of(context).size;
        return Container(
          color: Color.lerp(Colors.transparent, Colors.black38, bgPercent),
          width: size.width,
          height: size.height,
        );
      },
    );

    overlay.insert(overlayEntryBackground!);

    overlay.insert(overlayEntry!);

    animationController.forward();

    return dragInfo;
  }

  void dragUpdate(DragInfo item, Offset position, Offset delta) {
    setState(() {
      overlayEntry?.markNeedsBuild();
      dragUpdateItems();
      autoScroller?.startAutoScrollIfNecessary(dragTargetRect);
    });
  }

  void dragCancel(DragInfo item) {
    dragReset();
  }

  void dragEnd(DragInfo item) {
    currentPosition = itemOffsetAt(swapIndex!);
    animationController.reverse();
  }

  void dropCompleted() {
    final int fromIndex = dragIndex!;
    final int toIndex = swapIndex!;
    if (fromIndex != toIndex) {
      final ItemState dragItemCurrent =
          itemStates[currentIndexes.indexOf(dragIndex!)]!;

      dragItemCurrent.springBack();
      widget.reorder(fromIndex, toIndex);
    }
    setState(() {
      dragReset();
      currentIndexes = List.generate(20, (index) => index, growable: true);
    });
  }

  void dragReset() {
    if (dragInfo != null) {
      if (dragIndex != null && itemStates.containsKey(dragIndex)) {
        final ItemState dragItem = itemStates[dragIndex!]!;
        dragItem.dragging = false;
        if (dragIndex != swapIndex) {
          dragItem.springReset();
        } else {
          dragItem.springBack();
        }
        dragItem.rebuild();
        dragIndex = null;
      }
      dragInfo?.dispose();
      dragInfo = null;
      resetItemGap();
      _recognizer?.dispose();
      _recognizer = null;

      overlayEntryBackground?.remove();
      overlayEntryBackground?.dispose();
      overlayEntryBackground = null;

      overlayEntry?.remove();
      overlayEntry?.dispose();
      overlayEntry = null;
      currentPosition = null;
    }
  }

  void resetItemGap() {
    for (final ItemState item in itemStates.values) {
      item.resetGap();
    }
  }

  void dragUpdateItems() {
    assert(dragInfo != null);
    int newIndex = swapIndex!;

    final dragCenter = dragInfo!.itemSize
        .center(dragInfo!.dragPosition - dragInfo!.dragOffset);

    for (final ItemState item in itemStates.values) {
      if (!item.mounted) {
        continue;
      }

      final Rect geometry = item.targetInitialGeometry;

      if (geometry.contains(dragCenter)) {
        newIndex = item.index;
        break;
      }
    }

    if (newIndex != swapIndex) {
      swapIndex = newIndex;

      int indexOfDrag = currentIndexes.indexOf(dragIndex!);

      int swapedItem = currentIndexes[swapIndex!];

      int temp = currentIndexes[indexOfDrag];
      currentIndexes[indexOfDrag] = currentIndexes[swapIndex!];
      currentIndexes[swapIndex!] = temp;

      for (final ItemState item in itemStates.values) {
        if (swapedItem == item.index) {
          item.updateForGap(currentIndexes, dragInfo!.itemExtent, true);
        }
      }
    }
  }

  void handleScrollableAutoScrolled() {
    if (dragInfo == null) {
      return;
    }
    dragUpdateItems();
    autoScroller?.startAutoScrollIfNecessary(dragTargetRect);
  }

  Offset itemOffsetAt(int index) {
    final box = itemStates[index]?.context.findRenderObject() as RenderBox?;
    if (box == null) return Offset.zero;

    return box.localToGlobal(Offset.zero);
  }

  @override
  Widget build(BuildContext context) {
    return MyReordonableSliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final int unmodifiedIndex = widget.items[index].index;
        return MyReordonableDelayedDrag(
            key: ValueKey('key-$index'),
            index: index,
            child: Item(
              key: ValueKey('item-$index'),
              index: index,
              crossAxis: 2,
              child: ItemContentWidget(
                key: ValueKey('content-$unmodifiedIndex'),
                item: widget.items[index],
                currentIndex: index,
                itemsCount: widget.items.length,
              ),
            ));
      },
    );
  }
}
