import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation46/widgets/onboarding_widget.dart';

class Animation46Screen extends StatefulWidget {
  const Animation46Screen({super.key});

  @override
  State<Animation46Screen> createState() => _Animation46ScreenState();
}

class _Animation46ScreenState extends State<Animation46Screen>
    with TickerProviderStateMixin {
  final List<Color> slides = [
    Colors.purple,
    Colors.orange,
    Colors.amber,
    Colors.pink
  ];

  Alignment offsetToAlignment(Offset offset, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final double xAlignment = (offset.dx - center.dx) / (size.width / 2);
    final double yAlignment = (offset.dy - center.dy) / (size.height / 2);

    return Alignment(xAlignment, yAlignment);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      body: OnBoardingsWidget(vsync: this, children: [
        ...slides.mapIndexed((index, e) => RepaintBoundary(
              child: SizedBox(
                width: width,
                height: height,
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.2,
                    ),
                    SizedBox(
                      width: width * 0.45,
                      height: width * 0.45,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Align(
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        width * 0.45 * 0.5),
                                    color: Colors.white)),
                          ),
                          Align(
                            child: SizedBox(
                              width: width * 0.4,
                              height: width * 0.4,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(width * 0.2),
                                child: Image.asset(
                                  'images/movie${index + 1}.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Material(
                      type: MaterialType.transparency,
                      child: Text(
                        'Harry potter',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: width * 0.6,
                      child: const Material(
                        type: MaterialType.transparency,
                        child: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit,sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Watch now',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ))
                  ],
                ),
              ),
            ))
      ]),
    );
  }
}
