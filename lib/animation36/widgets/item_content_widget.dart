import 'package:flutter/material.dart';
import 'package:flutter_me_animations/models/reordonable.dart';

class ItemContentWidget extends StatelessWidget {
  final int currentIndex;
  final int prevIndex;
  final Reordonable item;
  final int itemsCount;

  const ItemContentWidget(
      {super.key,
      required this.currentIndex,
      required this.itemsCount,
      required this.item,
      required this.prevIndex});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        height: item.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ...List.generate(
                    (currentIndex / 9).floor(),
                    (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: item.color,
                            child: const Text(
                              '9',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )),
                const SizedBox(
                  width: 10,
                ),
                ...List.generate(
                    currentIndex % 9,
                    (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        child: CircleAvatar(
                            radius: 8, backgroundColor: item.color)))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ...List.generate(
                    (prevIndex / 9).floor(),
                    (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: item.color,
                            child: const Text(
                              '9',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )),
                const SizedBox(
                  width: 10,
                ),
                ...List.generate(
                    prevIndex % 9,
                    (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          child: CircleAvatar(
                              radius: 8, backgroundColor: item.color),
                        )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
