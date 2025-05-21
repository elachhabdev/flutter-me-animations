import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation4/widgets/box_image_widget.dart';
import 'package:flutter_me_animations/animation4/widgets/box_title_widget.dart';
import 'package:flutter_me_animations/animation4/widgets/title_detail_widget.dart';
import 'package:flutter_me_animations/models/slide.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class Animation4DetailScreen extends StatefulWidget {
  const Animation4DetailScreen({super.key});

  @override
  State<Animation4DetailScreen> createState() => _Animation4DetailScreenState();
}

class _Animation4DetailScreenState extends State<Animation4DetailScreen>
    with SingleTickerProviderStateMixin, RouteAware {
  final List<Slide> slides = const [
    Slide(
        index: 0,
        title: 'Oculus Rift',
        image: 'image3.png',
        color: Colors.orange),
    Slide(
        index: 1,
        title: 'Oculus Quest',
        image: 'image3.png',
        color: Colors.indigo),
    Slide(
        index: 2,
        title: 'Shutter Pico',
        image: 'image3.png',
        color: Colors.purple),
    Slide(
      index: 3,
      title: 'Oculus VR',
      image: 'image3.png',
      color: Colors.blue,
    ),
  ];

  late AnimationController animationController;

  late ImageProvider imageProvider;

  late ImageProvider imageProviderLogo;

  late List<String> title;

  late int index;

  late double width;

  late double height;

  late double circlesize;

  late double fem;

  canpopanim(status) {
    if (status == AnimationStatus.dismissed) {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
        reverseDuration: const Duration(milliseconds: 800));

    Future.delayed(const Duration(milliseconds: 800), () {
      animationController.forward();
    });

    animationController.addStatusListener(canpopanim);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final route =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final Size size = MediaQuery.of(context).size;

    index = route['id'];

    title = slides[index].title.split('');

    imageProvider = const AssetImage('images/yacht.webp');

    imageProviderLogo = AssetImage('images/${slides[index].image}');

    precacheImage(imageProvider, context);

    precacheImage(imageProviderLogo, context);

    width = size.width;

    height = size.height;

    circlesize = sqrt(pow(width, 2) + pow(height, 2));

    fem = width / AppUtils.baseWidth;
  }

  @override
  void dispose() {
    animationController.removeStatusListener(canpopanim);
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (poped, res) {
        animationController.reverse();
      },
      child: Scaffold(
          body: Stack(fit: StackFit.expand, children: [
        Positioned(
            top: 40 * fem,
            left: 40 * fem,
            child: TitleDetailWidget(
                animationController: animationController,
                slide: slides[index],
                title: title)),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: OverflowBox(
                maxHeight: circlesize,
                maxWidth: circlesize,
                alignment: Alignment.center,
                child: Hero(
                  tag: 'circle-$index',
                  child: Container(
                    width: circlesize,
                    height: circlesize,
                    decoration: BoxDecoration(
                        color: slides[index].color.withValues(alpha: 0.2),
                        shape: BoxShape.circle),
                  ),
                )),
          ),
        ),
        Positioned.fill(
          top: height * 0.25,
          child: Align(
            alignment: Alignment.topCenter,
            child: Hero(
              tag: 'image-$index',
              child: Image(
                image: imageProviderLogo,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Positioned.fill(
            child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.all(40.0 * fem),
            child: SizedBox(
              height: 120 * fem,
              child: Row(
                children: [
                  BoxTitleWidget(animationController: animationController),
                  BoxImageWidget(
                      animationController: animationController,
                      imageProvider: imageProvider)
                ],
              ),
            ),
          ),
        ))
      ])),
    );
  }
}
