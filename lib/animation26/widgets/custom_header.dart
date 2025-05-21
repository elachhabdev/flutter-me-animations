import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class Customheader extends SliverPersistentHeaderDelegate {
  final double maxheight;
  final double minheight;

  Customheader({required this.minheight, required this.maxheight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final fem = MediaQuery.of(context).size.width / AppUtils.baseWidth;
    return Container(
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Colors.teal, Colors.indigo]),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: const Offset(0.0, 0.0),
              blurRadius:
                  lerpDouble(0, 7, (shrinkOffset / maxheight).clamp(0.0, 1.0))!,
              spreadRadius:
                  lerpDouble(0, 7, (shrinkOffset / maxheight).clamp(0.0, 1.0))!,
            )
          ]),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          padding: const EdgeInsets.all(10),
          width: 100 * fem,
          color: Colors.white,
          child: Text(
            'Arrive By',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.teal,
                fontSize: 16 * fem,
                fontWeight: FontWeight.w500),
          ),
        ),
        const Spacer(),
        Text(
          'Traffic',
          style: TextStyle(
              color: Colors.white70,
              fontSize: 16 * fem,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          width: 10 * fem,
        )
      ]),
    );
  }

  @override
  double get maxExtent => maxheight;

  @override
  double get minExtent => minheight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
