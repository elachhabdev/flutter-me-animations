import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation6/widgets/plat_content_widget.dart';
import 'package:flutter_me_animations/animation6/widgets/plat_widget.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class Animation6Screen extends StatefulWidget {
  const Animation6Screen({super.key});

  @override
  State<Animation6Screen> createState() => _Animation6ScreenState();
}

class _Animation6ScreenState extends State<Animation6Screen> {
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
      'place': 'Italie',
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
      'place': 'Italie',
      'desc':
          'Not all meals look exactly like the Canada’s food guide plate. Use the plate proportions as a reference tool whether your meal '
    },
  ];

  late PageController pageController;

  final ValueNotifier<double> page = ValueNotifier(0.0);

  final ValueNotifier<int> currentindex = ValueNotifier(0);

  List<ImageProvider> imageProviders = [];

  pagelistener() {
    double pageC = pageController.page!;

    page.value = pageC;

    int currentindexC =
        (pageC - pageC.floor()) > 0.5 ? pageC.round() : pageC.floor();

    if (currentindexC != currentindex.value) {
      currentindex.value = currentindexC;
    }
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    pageController.addListener(pagelistener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    for (var plat in plats) {
      ImageProvider imageProvider = AssetImage(plat['image']);
      precacheImage(imageProvider, context);
      imageProviders.add(imageProvider);
    }
  }

  @override
  void dispose() {
    currentindex.dispose();
    page.dispose();
    pageController.removeListener(pagelistener);
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final fem = width / AppUtils.baseWidth;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: page,
              builder: (context, child) {
                return SingleChildScrollView(
                    child: Transform.translate(
                  offset: Offset(0.0, -page.value * height),
                  child: child,
                ));
              },
              child: Column(
                children: [
                  ...plats.map((e) => Container(
                        height: height,
                        color: e['bg'],
                      ))
                ],
              ),
            ),
          ),
          Positioned.fill(
              child: PlatWidget(
                  page: page,
                  plats: plats,
                  currentindex: currentindex,
                  imageProviders: imageProviders)),
          Positioned.fill(
              left: 20 * fem,
              child: PlatContentWidget(
                page: page,
                plats: plats,
                currentindex: currentindex,
              )),
          Positioned.fill(
              child: PageView.builder(
                  controller: pageController,
                  itemCount: plats.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) => const SizedBox())),
          Positioned(
              bottom: 30 * fem,
              right: 30 * fem,
              width: 50 * fem,
              height: 50 * fem,
              child: Hero(
                tag: 'button',
                child: Transform.rotate(
                  angle: pi / 4,
                  child: GestureDetector(
                    onTap: () {
                      int currentindex = (page.value - page.value.floor()) > 0.5
                          ? page.value.round()
                          : page.value.floor();
                      Navigator.of(context).pushNamed('animation6/detail',
                          arguments: {'id': currentindex});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Transform.rotate(
                        angle: -pi / 4,
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
