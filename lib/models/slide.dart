import 'package:flutter/material.dart';

class Slide {
  final String title;
  final String image;
  final int index;
  final Color color;

  const Slide(
      {required this.color,
      required this.index,
      required this.title,
      required this.image});
}
