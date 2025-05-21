import 'package:flutter/material.dart';

class CustomHeader extends SliverPersistentHeaderDelegate {
  final double boxHeight;
  CustomHeader({required this.boxHeight});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: maxExtent,
    );
  }

  @override
  double get maxExtent => boxHeight;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
