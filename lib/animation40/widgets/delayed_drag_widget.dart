import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation40/widgets/myreordonablegrid_widget.dart';

class MyReordonableDelayedDrag extends StatelessWidget {
  const MyReordonableDelayedDrag({
    super.key,
    required this.child,
    required this.index,
    this.enabled = true,
  });

  final Widget child;

  final int index;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: enabled
          ? (PointerDownEvent event) => _startDragging(context, event)
          : null,
      child: child,
    );
  }

  @protected
  MultiDragGestureRecognizer createRecognizer() {
    return DelayedMultiDragGestureRecognizer(debugOwner: this);
  }

  void _startDragging(BuildContext context, PointerDownEvent event) {
    final DeviceGestureSettings? gestureSettings =
        MediaQuery.maybeGestureSettingsOf(context);
    final MyReordonableGridState? list =
        MyReordonableGridState.maybeOf(context);
    list?.startItemDragReorder(
      index: index,
      event: event,
      recognizer: createRecognizer()..gestureSettings = gestureSettings,
    );
  }
}
