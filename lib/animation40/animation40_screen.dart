import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation40/widgets/myreordonablegrid_widget.dart';
import 'package:flutter_me_animations/models/reordonable.dart';

class Animation40Screen extends StatefulWidget {
  const Animation40Screen({super.key});

  @override
  State<Animation40Screen> createState() => _Animation40ScreenState();
}

class _Animation40ScreenState extends State<Animation40Screen> {
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
          color: Colors.green.withGreen((i / 20 * 255).toInt()),
          height: 60.0 + Random().nextInt(40),
          index: i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          MyReordonableGrid(items: items, reorder: reorder),
        ],
      ),
    );
  }
}
