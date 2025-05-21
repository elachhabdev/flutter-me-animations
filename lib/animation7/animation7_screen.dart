import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';
import 'package:flutter_me_animations/utils/widget_position_size.dart';

class Animation7Screen extends StatefulWidget {
  const Animation7Screen({super.key});

  @override
  State<Animation7Screen> createState() => _Animation7ScreenState();
}

class _Animation7ScreenState extends State<Animation7Screen> {
  final List<Map<String, dynamic>> slides = [
    {
      'id': 0,
      'title': 'Menu France',
    },
    {
      'id': 1,
      'title': 'Italie',
    },
    {
      'id': 2,
      'title': 'Great Britain',
    },
    {
      'id': 3,
      'title': 'Espagne',
    },
  ];

  late PageController pageController;

  final List<GlobalKey> listkeys = List.generate(4, (index) => GlobalKey());

  final List<double> listwidth = [];

  final List<double> listposition = [];

  final ValueNotifier<double> page = ValueNotifier(0.0);

  double widthindicator = 0;

  double positionindicator = 0;

  pagelistener() {
    page.value = pageController.page!;
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    pageController.addListener(pagelistener);
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      for (var key in listkeys) {
        listwidth.add(WidgetPosition.getSizesbyKey(key).width);
        listposition.add(WidgetPosition.getPositionsbyKey(key).dx);
      }

      setState(() {
        widthindicator = listwidth[0];
        positionindicator = listposition[0];
      });
    });
  }

  @override
  void dispose() {
    page.dispose();
    pageController.removeListener(pagelistener);
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final width = size.width;
    final fem = width / AppUtils.baseWidth;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            itemBuilder: (context, index) => Center(
                child: Text(
              '${slides[index]['title']}',
              style: TextStyle(fontSize: 20 * fem, color: Colors.white),
            )),
            itemCount: slides.length,
          ),
          Positioned(
              top: 80 * fem,
              child: AnimatedBuilder(
                animation: page,
                builder: (context, child) {
                  if (page.value > 0.0 && page.value < slides.length - 1) {
                    int currentindex = page.value.floor();
                    int nextindex = (page.value.floor() + 1);

                    double pagePercent = page.value - page.value.floor();

                    widthindicator = lerpDouble(listwidth[currentindex],
                        listwidth[nextindex], pagePercent)!;

                    positionindicator = lerpDouble(listposition[currentindex],
                        listposition[nextindex], pagePercent)!;
                  }

                  return Transform.translate(
                      offset: Offset(positionindicator, 0.0),
                      child: Container(
                        height: 40 * fem,
                        width: widthindicator,
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(30)),
                      ));
                },
              )),
          Positioned(
            top: 80 * fem,
            left: 20 * fem,
            child: Row(
              children: [
                ...slides.map((e) {
                  return Container(
                    key: listkeys[e['id']],
                    height: 40 * fem,
                    margin: EdgeInsets.symmetric(horizontal: 10 * fem),
                    alignment: Alignment.center,
                    child: AnimatedBuilder(
                        animation: page,
                        builder: (context, child) {
                          return Text(
                            '${e['title']}',
                            style: TextStyle(
                                color: Color.lerp(
                                    Colors.black,
                                    Colors.white,
                                    (e['id'] - page.value)
                                        .abs()
                                        .clamp(0.0, 1.0))),
                          );
                        }),
                  );
                })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
