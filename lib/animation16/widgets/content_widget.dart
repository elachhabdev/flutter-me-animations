import 'package:flutter/material.dart';

class ContentWidget extends StatelessWidget {
  final ValueNotifier<double> page;
  final double fem;
  final double contentHeight;
  const ContentWidget(
      {super.key,
      required this.page,
      required this.contentHeight,
      required this.fem});

  @override
  Widget build(BuildContext context) {
    final totalGap = 2 * 5 * fem + 10 * fem;
    const double totalElements = 3;

    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedBuilder(
            animation: page,
            builder: (context, child) {
              final double pagepercent = page.value - page.value.floor();

              return Opacity(
                  opacity: ((pagepercent < 0.5
                          ? 1 - 4 * (pagepercent)
                          : (4 * (pagepercent)) - 3)
                      .clamp(0.0, 1.0)),
                  child: child);
            },
            child: SizedBox(
              height: (contentHeight - 2 * totalGap) / totalElements,
              child: const FittedBox(
                child: Text(
                  "Harry Potter",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5 * fem,
          ),
          AnimatedBuilder(
            animation: page,
            builder: (context, child) {
              final double pagepercent = page.value - page.value.floor();

              return Opacity(
                  opacity: ((pagepercent < 0.5
                          ? 1 - 4 * (pagepercent)
                          : (4 * (pagepercent)) - 3)
                      .clamp(0.0, 1.0)),
                  child: child);
            },
            child: Column(
              children: [
                SizedBox(
                  height: (contentHeight - 2 * totalGap) / totalElements,
                  child: FittedBox(
                      child: Text(
                    'Great Movies ',
                    style: TextStyle(color: Colors.blueGrey.shade300),
                  )),
                ),
                SizedBox(
                  height: 5 * fem,
                ),
                SizedBox(
                    height: (contentHeight) / totalElements,
                    child: FittedBox(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white),
                          onPressed: () {},
                          child: const FittedBox(
                            child: Text(
                              '2023',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          )),
                    ))
              ],
            ),
          ),
          SizedBox(
            height: 10 * fem,
          ),
        ]);
  }
}
