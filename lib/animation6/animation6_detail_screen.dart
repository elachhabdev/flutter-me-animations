import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation6/widgets/plat_detail_widget.dart';

import 'dart:math';

import 'package:flutter_me_animations/utils/app_utils.dart';

class Animation6DetailScreen extends StatefulWidget {
  const Animation6DetailScreen({super.key});

  @override
  State<Animation6DetailScreen> createState() => _Animation6DetailScreenState();
}

class _Animation6DetailScreenState extends State<Animation6DetailScreen> {
  final List<Map<String, dynamic>> plats = [
    {
      'id': 1,
      'image': 'images/plat2.png',
      'color': Colors.green,
      'bg': Colors.white,
      'islight': true,
      'title': 'Roasted Beetroot \n& Egg Salad',
      'mode': 'Easy',
      'minute': '45 mins',
      'option': 'Healthy',
      'exp': '50 exp',
      'type': 'Fish',
      'desc':
          'The healthy food choices shown on the plate are only examples. The size and amount of each food shown on the plate'
    },
    {
      'id': 2,
      'image': 'images/plat3.png',
      'color': Colors.orange.shade900,
      'bg': Colors.blueGrey.shade900,
      'islight': false,
      'title': 'Tuna Salad \n& Red Cabbage',
      'mode': 'Moyen',
      'minute': '35 mins',
      'option': 'Healthy',
      'exp': '12 exp',
      'type': 'Salade',
      'desc':
          'Not all meals look exactly like the Canada’s food guide plate. Use the plate proportions as a reference tool whether your meal '
    },
  ];

  late ImageProvider imageProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final currentindex = args['id'];
    imageProvider = AssetImage(plats[currentindex]['image']);
    precacheImage(imageProvider, context);
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final currentindex = args['id'];
    final Size size = MediaQuery.of(context).size;
    final width = size.width;
    final fem = width / AppUtils.baseWidth;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: plats[currentindex]['bg'],
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: PlatDetailWidget(
                currentindex: currentindex,
                plats: plats,
                imageProvider: imageProvider,
              ),
            ),
            Positioned(
                bottom: 70 * fem,
                right: 30 * fem,
                width: 50 * fem,
                height: 50 * fem,
                child: Hero(
                  tag: 'button',
                  child: Transform.rotate(
                    angle: pi / 4,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Transform.rotate(
                          angle: -pi / 4,
                          child: const Icon(
                            Icons.dining,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
