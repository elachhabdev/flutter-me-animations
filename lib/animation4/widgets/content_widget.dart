import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/models/slide.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class ContentWidget extends StatelessWidget {
  final ValueNotifier<double> page;
  final int index;
  final Slide slide;
  const ContentWidget(
      {super.key,
      required this.page,
      required this.index,
      required this.slide});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final width = size.width;
    final fem = width / AppUtils.baseWidth;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: page,
          builder: (context, child) {
            return Transform.scale(
                scale: lerpDouble(
                    1.0, 0.5, (page.value - index).abs().clamp(0.0, 1.0)),
                child: child);
          },
          child: GestureDetector(
            onTap: () => Navigator.of(context)
                .pushNamed('animation4/detail', arguments: {'id': slide.index}),
            child: RepaintBoundary(
              child: Hero(
                tag: 'image-$index',
                child: Image.asset(
                  'images/${slide.image}',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5 * fem,
        ),
        Padding(
          padding: EdgeInsets.only(left: 70 * fem, right: 20 * fem),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedBuilder(
                  animation: page,
                  builder: (context, child) {
                    final percent =
                        ((page.value - index) * 2).abs().clamp(0.0, 1.0);

                    return Opacity(
                      opacity: Tween(begin: 1.0, end: 0.0).transform(percent),
                      child: Transform.translate(
                        offset:
                            Offset(lerpDouble(0.0, width * 0.3, percent)!, 0.0),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    slide.title,
                    style: TextStyle(
                        fontSize: 22 * fem,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  )),
              SizedBox(
                height: 10 * fem,
              ),
              AnimatedBuilder(
                  animation: page,
                  builder: (context, child) {
                    final percent =
                        ((page.value - index) * 2).abs().clamp(0.0, 1.0);

                    return Opacity(
                      opacity: Tween(begin: 1.0, end: 0.0).transform(percent),
                      child: Transform.translate(
                        offset: Offset(
                            lerpDouble(0.0, width * 0.25, percent)!, 0.0),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed dm, consectetur adipiscing ',
                    style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.3),
                        fontSize: 16 * fem),
                  ))
            ],
          ),
        )
      ],
    );
  }
}
