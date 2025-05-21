import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation25/widgets/container_widget.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class Animation25Screen extends StatefulWidget {
  const Animation25Screen({super.key});

  @override
  State<Animation25Screen> createState() => _Animation25ScreenState();
}

class _Animation25ScreenState extends State<Animation25Screen>
    with SingleTickerProviderStateMixin {
  final List<Color> colors = [
    Colors.purple.shade700,
    Colors.indigo.shade700,
    Colors.blue.shade700,
    Colors.black,
  ];

  final List childrens = [0, 1, 2, 3];

  final List text = ['Purple', 'Indigo', 'Blue', 'Black'];

  final ValueNotifier<Color> currentColor = ValueNotifier(Colors.blueGrey);

  updateColor(Color color, currentindex) {
    currentColor.value = color;
    childrens.remove(currentindex);
    childrens.add(currentindex);
  }

  @override
  void dispose() {
    currentColor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    final double fem = width / AppUtils.baseWidth;
    final double containerHeight = width * 0.25;
    final double gapInWidth = 5 * fem;
    final double gapOutWidth = 30 * fem;

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Stack(
        children: [
          Positioned.fill(
            child: ValueListenableBuilder(
                valueListenable: currentColor,
                builder: (context, color, child) {
                  return AnimatedContainer(
                      duration: const Duration(milliseconds: 1000),
                      decoration:
                          BoxDecoration(color: color.withValues(alpha: 0.6)));
                }),
          ),
          Align(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: gapInWidth),
              margin: EdgeInsets.symmetric(horizontal: gapOutWidth),
              height: containerHeight,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: ValueListenableBuilder(
                  valueListenable: currentColor,
                  builder: (context, _, child) {
                    return Stack(
                      children: [
                        ...childrens.map((e) => ContainerWidget(
                              key: ValueKey(e),
                              index: e,
                              title: text[e],
                              color: colors[e],
                              totalChildrens: childrens.length,
                              updateCurrentColor: updateColor,
                            )),
                      ],
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
