import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation12/widgets/article_widget.dart';
import 'package:flutter_me_animations/animation12/widgets/stacked_list_widget.dart';
import 'package:flutter_me_animations/animation12/widgets/stick_header_widget.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class Animation12Screen extends StatefulWidget {
  const Animation12Screen({super.key});

  @override
  State<Animation12Screen> createState() => _Animation12ScreenState();
}

class _Animation12ScreenState extends State<Animation12Screen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    final fem = width / AppUtils.baseWidth;
    final double maxHeight = 300 * fem;
    final double minHeigt = 100 * fem;
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
              pinned: true,
              delegate: MyStickyHeader(
                maxHeader: maxHeight,
                minHeader: minHeigt,
              )),
          MyStackedList(
            delegate: SliverChildListDelegate(List.generate(
                7,
                (index) => ArticleWidget(
                      maxHeight: maxHeight,
                      totalItems: 7,
                    ))),
          ),
          SliverList.builder(
              itemCount: 3,
              itemBuilder: (context, index) => ArticleWidget(
                    maxHeight: maxHeight,
                    totalItems: 7,
                  ))
        ],
      ),
    );
  }
}
