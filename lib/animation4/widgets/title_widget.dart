import 'package:flutter/material.dart';
import 'package:flutter_me_animations/models/slide.dart';

class TitleWidget extends StatelessWidget {
  final List<Slide> slides;
  const TitleWidget({super.key, required this.slides});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...slides.map((e) => Expanded(
              child: FittedBox(
                alignment: Alignment.topCenter,
                child: Text(
                  e.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ))
      ],
    );
  }
}
