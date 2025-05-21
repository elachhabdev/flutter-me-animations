import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation39/widgets/circle_slider_widget.dart';

class Animation39Screen extends StatefulWidget {
  const Animation39Screen({super.key});

  @override
  State<Animation39Screen> createState() => _Animation39ScreenState();
}

class _Animation39ScreenState extends State<Animation39Screen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularSliderWidget(vsync: this),
        ));
  }
}
