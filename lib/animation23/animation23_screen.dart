import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation23/widgets/curved_line_widget.dart';

import 'package:flutter_me_animations/utils/app_utils.dart';
import 'package:flutter_me_animations/utils/interpolations.dart';

class Animation23Screen extends StatefulWidget {
  const Animation23Screen({super.key});

  @override
  State<Animation23Screen> createState() => _Animation23ScreenState();
}

class _Animation23ScreenState extends State<Animation23Screen> {
  final ValueNotifier<double> translateY = ValueNotifier(0.0);

  final ValueNotifier<double> percent = ValueNotifier(0.5);

  late double height;

  late double width;

  late double fem;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Size size = MediaQuery.of(context).size;

    height = size.height;

    width = size.width;

    fem = width / AppUtils.baseWidth;

    translateY.value = height * 0.4;

    percent.value = 0.9;
  }

  @override
  void dispose() {
    translateY.dispose();
    percent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              left: width * 0.5,
              child: AnimatedBuilder(
                animation: translateY,
                builder: (context, child) {
                  return CustomPaint(
                      painter: CurvedLineCustom(percent: percent.value),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Transform.translate(
                            offset: Offset(0.0, translateY.value),
                            child: child),
                      ));
                },
                child: GestureDetector(
                  onPanUpdate: (details) {
                    translateY.value = (translateY.value + details.delta.dy)
                        .clamp(-height * 0.4 + 5, height * 0.4);
                    percent.value = inverselerp(
                            -height * 0.5, height * 0.5, translateY.value)
                        .clamp(0.0, 1.0);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.arrow_drop_up,
                          color: Colors.blueGrey,
                          size: 20,
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.blueGrey,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
