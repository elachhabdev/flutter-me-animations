import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation17/widgets/mysliverlist_screen.dart';

import 'widgets/animated_scroll_widget.dart';

class Animation17Screen extends StatefulWidget {
  const Animation17Screen({super.key});

  @override
  State<Animation17Screen> createState() => _Animation17ScreenState();
}

class _Animation17ScreenState extends State<Animation17Screen> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    const gap = 10.0;
    final paddingTop = MediaQuery.of(context).viewPadding.top + gap;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            MySliverList(
              delegate:
                  SliverChildBuilderDelegate(childCount: 20, (context, index) {
                return Container(
                  margin: const EdgeInsets.all(gap),
                  height: screenheight * 0.15,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.teal
                          .withBlue(lerpDouble(0, 255, (index / 20))!.toInt()),
                      borderRadius: BorderRadius.circular(15)),
                  child: AnimatedBuilder(
                      animation: scrollController,
                      builder: (context, child) {
                        return ScrollAnimatedWidget(
                            paddingTop: paddingTop, index: index, child: child);
                      },
                      child: Image.asset('images/plat3.png')),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
