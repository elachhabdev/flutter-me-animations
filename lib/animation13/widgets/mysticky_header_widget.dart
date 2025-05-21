import 'dart:ui';

import 'package:flutter/material.dart';

class HeaderList extends StatelessWidget {
  const HeaderList({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Text(
            'Today',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(
            width: 30,
          ),
          Text(
            '13 Mars',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(
            width: 30,
          ),
          Text(
            '14 Mars',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(
            width: 30,
          ),
          Text(
            '16 Mars',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(
            width: 30,
          ),
          Text(
            '17 Mars',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(
            width: 30,
          ),
          Text(
            '18 Mars',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

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
    final percent = shrinkOffset / maxExtent;

    return Stack(
      children: [
        const Positioned.fill(
          child: FractionallySizedBox(
            alignment: Alignment.topCenter,
            heightFactor: 0.8,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.blue, Colors.teal],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
            ),
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Opacity(
              opacity: (1 - percent * 3).clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(0.0, (-maxExtent) * percent),
                child: Row(
                  children: [
                    const Expanded(
                      child: FittedBox(
                        child: Text(
                          'VR - \nOCULUS VR',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: Image.asset(
                        'images/image3.png',
                        fit: BoxFit.contain,
                        width: 200,
                        height: 200,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
            child: FractionallySizedBox(
                alignment: Alignment.bottomLeft,
                heightFactor: lerpDouble(0.3, 0.4, percent),
                child: Container(
                    alignment: Alignment.lerp(
                        Alignment.bottomCenter, Alignment.center, percent),
                    padding: EdgeInsets.symmetric(
                        horizontal: 25, vertical: lerpDouble(25, 0, percent)!),
                    margin: EdgeInsets.symmetric(
                        horizontal: lerpDouble(0, 25, percent)!),
                    decoration: BoxDecoration(
                        color: Colors.teal.shade300,
                        borderRadius:
                            BorderRadius.circular(lerpDouble(0, 25, percent)!)),
                    child: const HeaderList()))),
        Positioned.fill(
          child: FractionallySizedBox(
            heightFactor: 0.8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Align(
                alignment: Alignment.lerp(
                    Alignment.bottomLeft, Alignment.topCenter, percent)!,
                child: Text(
                  'List Activities',
                  style: TextStyle(
                      color: Color.lerp(Colors.white70, Colors.white, percent),
                      fontSize: 18),
                ),
              ),
            ),
          ),
        ),
      ],
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
