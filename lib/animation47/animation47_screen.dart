import 'package:flutter/material.dart';

import 'package:flutter_me_animations/animation47/widgets/double_circle_slider_widget.dart';

class Animation47Screen extends StatefulWidget {
  const Animation47Screen({super.key});

  @override
  State<Animation47Screen> createState() => _Animation47ScreenState();
}

class _Animation47ScreenState extends State<Animation47Screen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: DoubleCircleSliderWidget(vsync: this),
        ));
  }
}
