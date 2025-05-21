import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation6/widgets/three_arc.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class PlatDetailWidget extends StatelessWidget {
  final List<Map<String, dynamic>> plats;
  final int currentindex;
  final ImageProvider imageProvider;

  const PlatDetailWidget({
    super.key,
    required this.currentindex,
    required this.plats,
    required this.imageProvider,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final fem = width / AppUtils.baseWidth;
    final containerImage = width * 0.7;

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: 80 * fem),
        Align(
          alignment: Alignment.center,
          child: Hero(
            tag: 'plat',
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..scale(1.1)
                ..rotateZ(2 * pi - pi / 2),
              child: CustomPaint(
                  size: Size(containerImage + 50, containerImage + 50),
                  painter: ThreeArc(
                      containerImage: containerImage,
                      color: plats[currentindex]['color']),
                  child: Container(
                    width: containerImage,
                    height: containerImage,
                    alignment: Alignment.center,
                    child: Image(
                      image: imageProvider,
                    ),
                  )),
            ),
          ),
        ),
        SizedBox(
          height: 70 * fem,
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 30 * fem, vertical: 5 * fem),
          child: Text(
            plats[currentindex]['title'],
            style: TextStyle(
                color: plats[currentindex]['islight']
                    ? Colors.blueGrey.shade900
                    : Colors.white,
                fontSize: 24 * fem,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 10 * fem,
        ),
        Padding(
          padding: EdgeInsets.only(left: 25 * fem),
          child: Row(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.timer_rounded,
                      color: plats[currentindex]['islight']
                          ? Colors.orange.shade900
                          : Colors.green),
                  SizedBox(
                    width: 10 * fem,
                  ),
                  SizedBox(
                    height: 20 * fem,
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${plats[currentindex]['minute']}',
                        style: TextStyle(
                          color: Colors.blueGrey.shade400,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 30 * fem,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.data_exploration_rounded,
                      color: plats[currentindex]['islight']
                          ? Colors.orange.shade900
                          : Colors.green),
                  SizedBox(
                    width: 10 * fem,
                  ),
                  SizedBox(
                    height: 20 * fem,
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${plats[currentindex]['exp']}',
                        style: TextStyle(
                          color: Colors.blueGrey.shade400,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20 * fem,
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0 * fem),
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: Colors.blueGrey.shade400,
            labelColor: plats[currentindex]['islight']
                ? Colors.blueGrey.shade800
                : Colors.white,
            indicatorColor: Colors.green,
            isScrollable: true,
            tabs: const [
              Tab(
                  child: Text(
                'INGREDIENTS',
              )),
              Tab(
                  child: Text(
                'METHOD',
              )),
            ],
          ),
        ),
        Container(
          height: height * 0.4,
          padding: EdgeInsets.only(left: 30 * fem),
          child: TabBarView(
            children: [
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 6,
                  itemBuilder: (context, index) => Container(
                        padding: EdgeInsets.only(bottom: 15 * fem),
                        child: Row(
                          children: [
                            Icon(
                              Icons.dining_rounded,
                              color: plats[currentindex]['islight']
                                  ? Colors.green
                                  : Colors.orange.shade900,
                            ),
                            SizedBox(
                              width: 20 * fem,
                            ),
                            Text(
                              'Ingredient Food index',
                              style: TextStyle(
                                  color: Colors.blueGrey.shade400,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      )),
              const Icon(Icons.directions_transit),
            ],
          ),
        ),
      ]),
    );
  }
}
