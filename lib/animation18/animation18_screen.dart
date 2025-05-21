import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation18/widgets/fab_widget.dart';

class Animation18Screen extends StatefulWidget {
  const Animation18Screen({super.key});

  @override
  State<Animation18Screen> createState() => _Animation18ScreenState();
}

class _Animation18ScreenState extends State<Animation18Screen> {
  final List<GlobalKey<FabWidgetState>> _listkeys =
      List.generate(5, (index) => GlobalKey<FabWidgetState>());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        ...List.generate(5, (index) => index + 1).asMap().entries.map((e) {
          return Align(
            alignment: Alignment.center,
            child: FabWidget(
              index: e.key,
              key: _listkeys[e.key],
            ),
          );
        }),
        Align(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () async {
              for (var i = 0; i < 5; i++) {
                Future.delayed(Duration(milliseconds: (100 * i)), () {
                  _listkeys[i].currentState!.toggle();
                });
              }
            },
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.brown.shade900,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
