import 'package:flutter/material.dart';
import 'package:flutter_me_animations/models/reordonable.dart';

class ItemContentWidget extends StatelessWidget {
  final int currentIndex;
  final Reordonable item;
  final int itemsCount;

  const ItemContentWidget({
    super.key,
    required this.currentIndex,
    required this.itemsCount,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          const Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.black,
                radius: 25,
                child: Icon(
                  Icons.alarm,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.spaceBetween,
            runSpacing: 10.0,
            children: [
              ...List.generate(
                  (currentIndex / 6).floor(),
                  (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        child: const CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.white,
                          child: Text(
                            '6',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      )),
              const SizedBox(
                width: 10,
              ),
              ...List.generate(
                currentIndex % 6,
                (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    child: const CircleAvatar(
                        radius: 8, backgroundColor: Colors.white)),
              ),
            ],
          )
        ]));
  }
}
