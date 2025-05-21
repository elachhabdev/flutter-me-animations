import 'package:flutter/material.dart';

class TrackDurationWidget extends StatelessWidget {
  final AnimationController animationController2;
  final int totalSecondSong;
  final double fem;
  const TrackDurationWidget(
      {super.key,
      required this.animationController2,
      required this.fem,
      required this.totalSecondSong});

  String formatDuration(Duration duration) {
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    String formattedDuration = '';

    if (minutes > 0) {
      if (formattedDuration.isNotEmpty) formattedDuration += ' ';
      formattedDuration += '$minutes ${minutes > 1 ? 'm' : 'm'}';
    }
    if (seconds > 0) {
      if (formattedDuration.isNotEmpty) formattedDuration += ' ';
      formattedDuration += '$seconds ${seconds > 1 ? 's' : 's'}';
    }

    return formattedDuration;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40 * fem),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedBuilder(
              animation: animationController2,
              builder: (context, child) {
                return Text(formatDuration(Duration(
                    seconds: (animationController2.value * (totalSecondSong))
                        .toInt())));
              }),
          const Text('4 m 35 s')
        ],
      ),
    );
  }
}
