import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation2/widgets/item_widget.dart';

class Animation2Screen extends StatefulWidget {
  const Animation2Screen({super.key});

  @override
  State<Animation2Screen> createState() => _Animation2ScreenState();
}

class _Animation2ScreenState extends State<Animation2Screen> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: PageView.builder(
          controller: pageController,
          itemCount: 3,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => Item(
                index: index,
                pageController: pageController,
              )),
    );
  }
}
