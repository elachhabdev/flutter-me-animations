import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation41/widgets/myreordonablegrid_widget.dart';
import 'package:flutter_me_animations/models/reordonable.dart';

class Animation41Screen extends StatefulWidget {
  const Animation41Screen({super.key});

  @override
  State<Animation41Screen> createState() => _Animation41ScreenState();
}

class _Animation41ScreenState extends State<Animation41Screen> {
  final List<Reordonable> items = [];

  reorder(int fromIndex, int toIndex) {
    setState(() {
      final Reordonable item = items.removeAt(fromIndex);
      items.insert(toIndex, item);
    });
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 20; i++) {
      items.add(Reordonable(color: Colors.white, height: 60.0, index: i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          MyReordonableGrid(items: items, reorder: reorder),
        ],
      ),
    );
  }
}
