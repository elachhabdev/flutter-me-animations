import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation27/widgets/content_widget.dart';
import 'package:flutter_me_animations/animation27/widgets/poster_widget.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class Animation27Screen extends StatefulWidget {
  const Animation27Screen({super.key});

  @override
  State<Animation27Screen> createState() => _Animation27ScreenState();
}

class _Animation27ScreenState extends State<Animation27Screen> {
  final ValueNotifier<double> page = ValueNotifier(0.0);

  final PageController pagecontroller = PageController(viewportFraction: 0.65);

  pagelistener() {
    page.value = pagecontroller.page!;
  }

  @override
  void initState() {
    super.initState();
    pagecontroller.addListener(pagelistener);
  }

  @override
  void dispose() {
    page.dispose();
    pagecontroller.removeListener(pagelistener);
    pagecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    final double fem = width / AppUtils.baseWidth;
    final double containerHeight = width * 0.75;
    final double containerImage = width * 0.75;
    final double gap = 10 * fem;

    return Scaffold(
        backgroundColor: Colors.blueGrey.shade100,
        body: Stack(children: [
          Positioned(
              height: containerHeight + gap,
              width: width,
              child: Container(
                decoration:
                    const BoxDecoration(color: Colors.black, boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0.0, 0.0),
                      spreadRadius: 5)
                ]),
              )),
          Positioned(
              height: containerHeight,
              width: width,
              child: Container(
                color: Colors.white,
              )),
          Positioned(
            top: 40 * fem,
            left: 20 * fem,
            child: Row(children: [
              Text(
                'My',
                style: TextStyle(color: Colors.black26, fontSize: 26 * fem),
              ),
              SizedBox(
                width: 10 * fem,
              ),
              Text(
                'Library',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 26 * fem),
              )
            ]),
          ),
          Positioned.fill(
            top: 10 * fem,
            child: PageView.builder(
              controller: pagecontroller,
              itemCount: 10,
              itemBuilder: (context, index) => Column(
                children: [
                  SizedBox(
                    height: containerHeight - containerImage + 2 * gap,
                  ),
                  PosterWidget(
                      containerHeight: containerHeight,
                      containerImage: containerImage,
                      fem: fem,
                      gap: gap,
                      index: index,
                      page: page),
                  ContentWidget(page: page, fem: fem, index: index)
                ],
              ),
            ),
          ),
        ]));
  }
}
