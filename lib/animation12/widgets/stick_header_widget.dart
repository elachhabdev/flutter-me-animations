import 'dart:ui';

import 'package:flutter/material.dart';

class MyStickyHeader extends SliverPersistentHeaderDelegate {
  final double maxHeader;
  final double minHeader;

  MyStickyHeader({
    required this.maxHeader,
    required this.minHeader,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.black,
      child: Stack(children: [
        Positioned.fill(
          left: 20,
          child: Align(
            alignment: Alignment.lerp(Alignment.centerLeft, Alignment.center,
                shrinkOffset / maxExtent)!,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Discover',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  color: Colors.red,
                  width: lerpDouble(4, 20, shrinkOffset / maxExtent),
                  height: 4,
                )
              ],
            ),
          ),
        ),
        Positioned.fill(
          top: 60,
          left: 25,
          child: Opacity(
            opacity: lerpDouble(
                1.0, 0.0, (shrinkOffset * 3 / maxExtent).clamp(0.0, 1.0))!,
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Lorem ipsum dolor sit amet consectetur ',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        )
      ]),
    );
  }

  @override
  double get maxExtent => maxHeader;

  @override
  double get minExtent => minHeader;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
