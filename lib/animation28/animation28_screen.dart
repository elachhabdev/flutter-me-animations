import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation28/widgets/text_duration_widget.dart';
import 'package:flutter_me_animations/animation28/widgets/track_duration_widget.dart';
import 'package:flutter_me_animations/animation28/widgets/track_progress_widget.dart';
import 'package:flutter_me_animations/animation28/widgets/vinyl_widget.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class Animation28Screen extends StatefulWidget {
  const Animation28Screen({super.key});

  @override
  State<Animation28Screen> createState() => _Animation28ScreenState();
}

class _Animation28ScreenState extends State<Animation28Screen>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  late AnimationController animationController2;

  final int durationSongMin = 4;

  final int durationSongSeconds = 35;

  final ValueNotifier<double> translateX = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this);
    animationController2 = AnimationController(
        vsync: this,
        duration:
            Duration(minutes: durationSongMin, seconds: durationSongSeconds));
    animationController2.forward();
  }

  @override
  void dispose() {
    translateX.dispose();
    animationController.dispose();
    animationController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int totalSecondSong = durationSongMin * 60 + durationSongSeconds;
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    final double fem = width / AppUtils.baseWidth;
    final double gap = 10 * fem;
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextDurationWidget(
                animationController: animationController,
                translateX: translateX),
            GestureDetector(
              onPanUpdate: (details) {
                translateX.value += details.delta.dx / width;
              },
              onPanStart: (details) {
                translateX.value = 0.0;
                animationController2.stop();
                animationController.fling(
                    velocity: 0.01,
                    springDescription: SpringDescription.withDampingRatio(
                      mass: 1.0,
                      stiffness: 1000.0,
                      ratio: 3.0,
                    ));
              },
              onPanEnd: (details) {
                animationController.fling(
                    velocity: -0.01,
                    springDescription: SpringDescription.withDampingRatio(
                      mass: 1.0,
                      stiffness: 1000.0,
                      ratio: 3.0,
                    ));

                final secondes = lerpDouble(0, 60, translateX.value)!.toInt();

                final secondesToforward = secondes / totalSecondSong;

                animationController2.forward(
                    from: animationController2.value + secondesToforward);
              },
              child: VinylWidget(
                  animationController: animationController,
                  animationController2: animationController2,
                  totalSecondSong: totalSecondSong,
                  translateX: translateX),
            ),
            Text(
              'David Bowie',
              style: TextStyle(fontSize: 18 * fem),
            ),
            SizedBox(
              height: 10 * fem,
            ),
            TrackProgressWidget(
                animationController2: animationController2, gap: gap),
            SizedBox(
              height: 5 * fem,
            ),
            TrackDurationWidget(
                animationController2: animationController2,
                fem: fem,
                totalSecondSong: totalSecondSong)
          ],
        ),
      ),
    );
  }
}
