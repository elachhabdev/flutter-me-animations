import 'package:flutter/material.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';
import 'package:flutter_me_animations/utils/snap_scroll_physics.dart';

class Animation5Screen extends StatefulWidget {
  const Animation5Screen({super.key});

  @override
  State<Animation5Screen> createState() => _Animation5ScreenState();
}

class _Animation5ScreenState extends State<Animation5Screen> {
  final List slides = [
    {'icon': Icons.lunch_dining, 'title': 'Hamburger'},
    {'icon': Icons.cake, 'title': 'Cake Flan'},
    {'icon': Icons.local_cafe, 'title': 'Cafe espresso'},
    {'icon': Icons.local_pizza, 'title': 'Pizza Italia'},
    {'icon': Icons.rice_bowl, 'title': 'Rice Bowl'},
    {'icon': Icons.ramen_dining, 'title': 'Ramen Dining'},
    {'icon': Icons.breakfast_dining, 'title': 'Breakfast Dining'},
  ];

  late ScrollController scrollController;

  late ScrollController scrollController2;

  scroll() {
    scrollController2.jumpTo(scrollController.offset);
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController2 = ScrollController();
    scrollController.addListener(scroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(scroll);
    scrollController.dispose();
    scrollController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final double fem = width / AppUtils.baseWidth;

    final middleIndex = ((height * 0.5 / (80 * fem))).floor();

    return Scaffold(
      body: SafeArea(
          child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: 0,
            height: height,
            width: 80 * fem,
            child: ListView.builder(
                controller: scrollController,
                physics: SnapScrollPhysics(snapSize: 80 * fem),
                itemBuilder: (context, index) {
                  final loopindex = (index) % slides.length;

                  return SizedBox(
                    height: 80 * fem,
                    width: 80 * fem,
                    child: Center(
                        child: Icon(
                      slides[loopindex]['icon'],
                      color: Colors.black,
                      size: 30 * fem,
                    )),
                  );
                }),
          ),
          Positioned(
            top: (80 * fem) * middleIndex,
            height: (80 * fem),
            width: width,
            child: const DecoratedBox(
                decoration: BoxDecoration(color: Colors.black)),
          ),
          Positioned(
            top: (80 * fem) * middleIndex,
            height: (80 * fem),
            width: width,
            child: ListView.builder(
                controller: scrollController2,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final loopindex = (index + middleIndex) % slides.length;

                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    padding: EdgeInsets.only(left: 20 * fem),
                    child: Row(
                      children: [
                        Text(
                          '${slides[loopindex]['title']}',
                          style: TextStyle(
                              color: Colors.white, fontSize: 24 * fem),
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 80 * fem,
                          width: 80 * fem,
                          child: Center(
                              child: Icon(
                            slides[loopindex]['icon'],
                            color: Colors.white,
                            size: 30 * fem,
                          )),
                        )
                      ],
                    ),
                  );
                }),
          ),
          Positioned.fill(
              top: height * 0.2,
              left: 30 * fem,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Im Hungry',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 32 * fem),
                  ),
                  Text(
                    'For',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 32 * fem),
                  )
                ],
              ))
        ],
      )),
    );
  }
}
