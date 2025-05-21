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
        child: Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Material(
              type: MaterialType.transparency,
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Calories',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      Icon(
                        Icons.account_tree_rounded,
                        color: Colors.white,
                      )
                    ],
                  ),
                  Text(
                    '4584',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    '4084',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    '5584',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    '3584',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Material(
                  type: MaterialType.transparency,
                  child: Text(
                    'Day',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Icon(
                  Icons.add_circle_rounded,
                  color: Colors.white,
                )
              ],
            ),
          ))
        ],
      ),
    ));
  }
}
