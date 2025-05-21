import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation32/widgets/circular_slider_widget.dart';

class Animation32Screen extends StatefulWidget {
  const Animation32Screen({super.key});

  @override
  State<Animation32Screen> createState() => _Animation32ScreenState();
}

class _Animation32ScreenState extends State<Animation32Screen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: CircularSliderWidget(),
    ));
  }
}
