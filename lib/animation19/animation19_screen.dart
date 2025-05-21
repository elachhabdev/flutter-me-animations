import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation19/widgets/content_widget.dart';
import 'package:flutter_me_animations/animation19/widgets/header_widget.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class Animation19Screen extends StatefulWidget {
  const Animation19Screen({super.key});

  @override
  State<Animation19Screen> createState() => _Animation19ScreenState();
}

class _Animation19ScreenState extends State<Animation19Screen> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((d) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final fem = width / AppUtils.baseWidth;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: CustomScrollView(
          controller: scrollController,
          reverse: true,
          slivers: [
            const SliverToBoxAdapter(
              child: HeaderWidget(),
            ),
            SliverPersistentHeader(
              delegate: StickyAppBottom(),
              floating: true,
              pinned: true,
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    childCount: 10, (context, index) => const ContentWidget())),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(10 * fem),
                child: Text(
                  'Lorem ipsum dolor sit amet',
                  style: TextStyle(color: Colors.white, fontSize: 24 * fem),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class StickyAppBottom extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final percent = shrinkOffset / maxExtent;
    final width = MediaQuery.of(context).size.width;
    final fem = width / AppUtils.baseWidth;
    return Container(
      color: Colors.indigo,
      padding: EdgeInsets.all(15 * fem),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            const Icon(
              Icons.remove_red_eye,
              color: Colors.white,
            ),
            SizedBox(
              width: 10 * fem,
            ),
            Text(
              '23',
              style: TextStyle(color: Colors.white, fontSize: 14 * fem),
            )
          ],
        ),
        Row(
          children: [
            Opacity(
              opacity: ((1 - (percent * 1.2)).clamp(0.0, 1.0)),
              child: const Icon(
                Icons.downloading,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 30 * fem,
            ),
            Transform.translate(
              offset: Offset(lerpDouble(0.0, 60.0 * fem, percent)!, 0.0),
              child: const Icon(
                Icons.favorite,
                color: Colors.red,
              ),
            ),
            SizedBox(
              width: 30 * fem,
            ),
            Opacity(
              opacity: ((1 - (percent * 1.2)).clamp(0.0, 1.0)),
              child: const Icon(
                Icons.ios_share_rounded,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 30 * fem,
            ),
          ],
        )
      ]),
    );
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
