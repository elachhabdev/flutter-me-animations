import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation36/widgets/myreordonablelist_widget.dart';
import 'package:flutter_me_animations/models/reordonable.dart';

class Animation36Screen extends StatefulWidget {
  const Animation36Screen({super.key});

  @override
  State<Animation36Screen> createState() => _Animation36ScreenState();
}

class _Animation36ScreenState extends State<Animation36Screen> {
  final List<Reordonable> items = [];

  reorder(fromIndex, toIndex) {
    setState(() {
      final Reordonable item = items.removeAt(fromIndex);
      items.insert(toIndex, item);
    });
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 20; i++) {
      items.add(Reordonable(
          color: Colors.purple.withGreen((i / 20 * 255).toInt()),
          height: 60.0 + Random().nextInt(40),
          index: i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MyReordonableList(items: items, reorder: reorder),
        ],
      ),
    );
  }
}
