import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation13/widgets/mysticky_header_widget.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class Animation13Screen extends StatefulWidget {
  const Animation13Screen({super.key});

  @override
  State<Animation13Screen> createState() => _Animation13ScreenState();
}

class _Animation13ScreenState extends State<Animation13Screen> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double fem = width / AppUtils.baseWidth;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: CustomScrollView(slivers: [
          SliverPersistentHeader(
              pinned: true,
              delegate:
                  MyStickyHeader(maxHeader: 350 * fem, minHeader: 150 * fem)),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  childCount: 10,
                  (context, index) => Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 25 * fem, vertical: 10 * fem),
                        child: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ',
                          style: TextStyle(
                              fontSize: 15 * fem, color: Colors.white),
                        ),
                      )))
        ]),
      ),
    );
  }
}
