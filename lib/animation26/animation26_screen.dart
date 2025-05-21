import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation26/widgets/content_widget.dart';
import 'package:flutter_me_animations/animation26/widgets/custom_header.dart';
import 'package:flutter_me_animations/animation26/widgets/lead_content_widget.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';
import 'package:flutter_me_animations/utils/snap_scroll_physics.dart';

class Animation26Screen extends StatefulWidget {
  const Animation26Screen({super.key});

  @override
  State<Animation26Screen> createState() => _Animation26ScreenState();
}

class _Animation26ScreenState extends State<Animation26Screen> {
  final ValueNotifier<double> page = ValueNotifier(0.0);
  final ScrollController scrollController = ScrollController();
  final ScrollController scrollController2 = ScrollController();

  final int slides = 16;

  final int starthours = 12;

  late double height;

  late double width;

  late double fem;

  late double containerHeight;

  pagelistener() {
    scrollController2.jumpTo(scrollController.offset);
    page.value = scrollController.position.pixels / (containerHeight);
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(pagelistener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Size size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    fem = width / AppUtils.baseWidth;
    containerHeight = height * 0.1;
  }

  @override
  void dispose() {
    scrollController2.dispose();
    scrollController.removeListener(pagelistener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Positioned(
          height: containerHeight,
          width: width,
          top: height * 0.7,
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.teal.shade300),
          ),
        ),
        Positioned(
          height: containerHeight,
          width: width,
          top: height * 0.7,
          child: ListView.builder(
            controller: scrollController2,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final minute = index * (slides - 1) % 60;
              final hours = starthours + ((index * (slides - 1)) / 60).floor();
              return ContentWidget(
                containerHeight: containerHeight,
                fem: fem,
                hours: hours,
                index: index + 1,
                minutes: minute,
              );
            },
          ),
        ),
        Positioned(
          height: height,
          width: 100 * fem,
          child: const DecoratedBox(
              decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [Colors.indigo, Colors.teal]))),
        ),
        CustomScrollView(
          physics: SnapScrollPhysics(snapSize: containerHeight),
          controller: scrollController,
          slivers: [
            SliverPersistentHeader(
                pinned: true,
                delegate: Customheader(
                  minheight: height * 0.2,
                  maxheight: height * 0.7,
                )),
            SliverList(
                delegate: SliverChildBuilderDelegate(
              childCount: slides,
              (context, index) {
                final minute = index * (slides - 1) % 60;
                final hours =
                    starthours + ((index * (slides - 1)) / 60).floor();

                if (index == slides - 1) {
                  return Container(
                    height: height * 0.2,
                    color: Colors.white,
                  );
                }
                return LeadContentWidget(
                    index: index,
                    minutes: minute,
                    containerHeight: containerHeight,
                    fem: fem,
                    hours: hours,
                    page: page);
              },
            ))
          ],
        ),
      ]),
    );
  }
}
