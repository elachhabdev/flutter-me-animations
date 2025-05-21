import 'package:flutter/material.dart';

class WidgetPosition {
  static Size getSizesbyKey(GlobalKey key) {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size;
    return size ?? Size.zero;
  }

  static Offset getPositionsbyKey(GlobalKey key) {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    final position = renderBox?.localToGlobal(Offset.zero);
    return position ?? Offset.zero;
  }

  static Size getSizesbyContext(BuildContext? context) {
    final RenderBox? renderBox = context?.findRenderObject() as RenderBox?;
    final size = renderBox?.size;
    return size ?? Size.zero;
  }

  static Offset getPositionsbyContext(BuildContext? context) {
    final RenderBox? renderBox = context?.findRenderObject() as RenderBox?;
    final position = renderBox?.localToGlobal(Offset.zero);
    return position ?? Offset.zero;
  }
}
