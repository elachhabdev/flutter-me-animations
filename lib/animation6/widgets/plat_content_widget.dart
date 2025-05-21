import 'package:flutter/material.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class PlatContentWidget extends StatelessWidget {
  final ValueNotifier<double> page;
  final ValueNotifier<int> currentindex;
  final List<Map<String, dynamic>> plats;

  final List<String> types = [
    'mode',
    'minute',
    'option',
    'exp',
    'type',
    'place'
  ];

  final List<IconData> icons = [
    Icons.dining,
    Icons.timer_rounded,
    Icons.adobe_sharp,
    Icons.data_exploration_rounded,
    Icons.temple_hindu_rounded,
    Icons.place_rounded
  ];

  PlatContentWidget({
    super.key,
    required this.page,
    required this.currentindex,
    required this.plats,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final width = size.width;
    final fem = width / AppUtils.baseWidth;

    return RepaintBoundary(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 30 * fem,
        ),
        Icon(
          Icons.arrow_back,
          color: Colors.blueGrey.shade300,
          size: 24 * fem,
        ),
        SizedBox(
          height: 30 * fem,
        ),
        Text(
          'DAILY COOKING QUEST',
          style: TextStyle(
            color: Colors.blueGrey.shade400,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 20 * fem,
        ),
        AnimatedBuilder(
          animation: page,
          builder: (context, child) {
            final double pagePercent = (page.value - page.value.floor());
            return ClipRect(
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                    height: 80 * fem,
                    child: Transform.translate(
                        offset: Offset(
                            0.0,
                            pagePercent < 0.5
                                ? -80 * 2 * fem * pagePercent
                                : -80 * 2 * fem * (1 - pagePercent)),
                        child: child)));
          },
          child: ValueListenableBuilder(
              valueListenable: currentindex,
              builder: (context, currentIndex, child) {
                return Text(
                  plats[currentIndex]['title'],
                  style: TextStyle(
                    color: plats[currentIndex]['islight']
                        ? Colors.blueGrey.shade900
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24 * fem,
                  ),
                );
              }),
        ),
        SizedBox(
          height: 50 * fem,
        ),
        ...List.generate(
          types.length,
          (index) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ValueListenableBuilder(
                      valueListenable: currentindex,
                      builder: (context, currentIndex, child) {
                        return Icon(icons[index],
                            color: plats[currentIndex]['islight']
                                ? Colors.orange.shade900
                                : Colors.green);
                      }),
                  SizedBox(
                    width: 10 * fem,
                  ),
                  AnimatedBuilder(
                    animation: page,
                    builder: (context, child) {
                      double pagePercent = (page.value - page.value.floor());

                      return ClipRect(
                        clipBehavior: Clip.hardEdge,
                        child: SizedBox(
                          height: 20 * fem,
                          child: Transform.translate(
                              offset: Offset(
                                  0.0,
                                  (pagePercent) < 0.5
                                      ? 40 * fem * pagePercent
                                      : 40 * fem * (1 - pagePercent)),
                              child: child),
                        ),
                      );
                    },
                    child: ValueListenableBuilder(
                        valueListenable: currentindex,
                        builder: (context, currentIndex, child) {
                          return FittedBox(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${plats[currentIndex][types[index]]}',
                              style: TextStyle(
                                color: Colors.blueGrey.shade400,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }),
                  )
                ],
              ),
              SizedBox(
                height: 20 * fem,
              ),
            ],
          ),
        ),
        const Spacer(),
        AnimatedBuilder(
          animation: page,
          builder: (context, child) {
            double pagePercent = (page.value - page.value.floor());

            return ClipRect(
              clipBehavior: Clip.hardEdge,
              child: Container(
                  width: width - 100 * fem,
                  height: 140 * fem,
                  alignment: Alignment.topLeft,
                  child: Transform.translate(
                    offset: Offset(
                        0.0,
                        pagePercent < 0.5
                            ? -140 * fem * pagePercent
                            : -140 * fem * (1 - pagePercent)),
                    child: child,
                  )),
            );
          },
          child: ValueListenableBuilder(
              valueListenable: currentindex,
              builder: (context, currentIndex, child) {
                return Text(
                  '${plats[currentIndex]['desc']}',
                  style: TextStyle(
                      color: plats[currentIndex]['islight']
                          ? Colors.blueGrey.shade400
                          : Colors.blueGrey.shade400.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                      fontSize: 14 * fem),
                );
              }),
        ),
      ]),
    );
  }
}
