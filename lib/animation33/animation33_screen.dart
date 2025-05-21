import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation33/widgets/arrow_widget.dart';

class Particle {
  final Offset position;

  Particle({required this.position});
}

class Animation33Screen extends StatefulWidget {
  const Animation33Screen({super.key});

  @override
  State<Animation33Screen> createState() => _Animation33ScreenState();
}

class _Animation33ScreenState extends State<Animation33Screen> {
  final ValueNotifier<Offset> positionCenter =
      ValueNotifier(const Offset(0.0, 0.0));

  double translateX = 0.0;

  double translateY = 0.0;

  late double itemHeight;

  late double itemWidth;

  late double height;

  late double width;

  final double circle = 30.0;

  int columns = 10;

  int rows = 14;

  List<Particle> particles = [];

  late Offset origin;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Size size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    itemHeight = (height / rows);
    itemWidth = (width / columns);

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < columns; col++) {
        particles.add(
            Particle(position: Offset(col * (itemWidth), row * (itemHeight))));
      }
    }

    origin = Offset((width * 0.5), (height * 0.5));
  }

  @override
  void dispose() {
    positionCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            left: itemWidth * 0.5,
            top: itemHeight * 0.5,
            child: AnimatedBuilder(
                animation: positionCenter,
                builder: (context, child) {
                  return CustomPaint(
                    painter: ArrowPainter(
                        itemSize: Size(itemWidth, itemHeight),
                        origin:
                            origin - Offset(itemWidth * 0.5, itemHeight * 0.5),
                        circle: circle,
                        particles: particles,
                        currentCircle: positionCenter.value),
                  );
                }),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: AnimatedBuilder(
                animation: positionCenter,
                builder: (context, child) {
                  return Transform.translate(
                    offset: positionCenter.value,
                    child: GestureDetector(
                        onPanUpdate: (details) {
                          translateX = (translateX + details.delta.dx).clamp(
                              -width / 2 + circle / 2, width / 2 - circle / 2);
                          translateY = (translateY + details.delta.dy).clamp(
                              -height / 2 + circle / 2,
                              height / 2 - circle / 2);

                          positionCenter.value = Offset(translateX, translateY);
                        },
                        child: child),
                  );
                },
                child: Container(
                  width: circle,
                  height: circle,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.indigo),
                  child: Container(
                    height: circle / 2,
                    width: circle / 2,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
