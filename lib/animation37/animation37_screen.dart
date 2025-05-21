import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_me_animations/animation37/widgets/color_picker_widget.dart';
import 'package:flutter_me_animations/animation37/widgets/color_wheel_widget.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class Animation37Screen extends StatefulWidget {
  const Animation37Screen({super.key});

  @override
  State<Animation37Screen> createState() => _Animation37ScreenState();
}

class _Animation37ScreenState extends State<Animation37Screen>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<Offset> picker = ValueNotifier(Offset.zero);

  final ValueNotifier<Offset> translate = ValueNotifier(Offset.zero);

  double angle = 0.0;

  double hue = 0.0;

  double saturation = 0.0;

  bool pickerExpanded = false;

  final double heightpicker = 60;

  final double widthpicker = 40;

  late double height;

  late double width;

  late double maxRaduis;

  late Offset origin;

  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController.unbounded(vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Size size = MediaQuery.of(context).size;

    height = size.height;

    width = size.width;

    picker.value =
        Offset(width * 0.5 - widthpicker * 0.5, height * 0.5 - heightpicker);
    maxRaduis = width * 0.8 * 0.5;
    origin =
        Offset(width * 0.5 - widthpicker * 0.5, height * 0.5 - heightpicker);
  }

  @override
  void dispose() {
    animationController.dispose();
    picker.dispose();
    translate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.center,
                  child: ShaderBuilder(assetKey: 'shaders/hueCircle.frag',
                      (context, shader, child) {
                    return RepaintBoundary(
                      child: CustomPaint(
                        size: Size(width * 0.85, width * 0.85),
                        painter: ColorWheelWidget(shader: shader),
                      ),
                    );
                  })),
              Align(
                  alignment: Alignment.center,
                  child: RepaintBoundary(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: SizedBox(
                        height: width * 0.85,
                        width: width * 0.85,
                      ),
                    ),
                  )),
              Align(
                  alignment: Alignment.center,
                  child: ShaderBuilder(assetKey: 'shaders/hueCircle.frag',
                      (context, shader, child) {
                    return RepaintBoundary(
                      child: CustomPaint(
                        size: Size(width * 0.8, width * 0.8),
                        painter: ColorWheelWidget(shader: shader),
                      ),
                    );
                  })),
              AnimatedBuilder(
                animation: picker,
                builder: (context, child) {
                  return Transform(
                    transform: Matrix4.identity()
                      ..translate(picker.value.dx, picker.value.dy),
                    child: GestureDetector(
                      onPanStart: (details) {
                        if (!pickerExpanded) {
                          animationController.animateWith(SpringSimulation(
                              const SpringDescription(
                                  mass: 1, stiffness: 100, damping: 3),
                              0.0,
                              1.0,
                              0.01));
                          pickerExpanded = true;
                        }
                      },
                      onPanUpdate: (details) {
                        translate.value += details.delta;

                        final angle =
                            atan2(translate.value.dy, translate.value.dx);

                        final double raduis = translate.value.distance;

                        picker.value = Offset(
                                raduis.clamp(-maxRaduis, maxRaduis) *
                                    cos(angle),
                                raduis.clamp(-maxRaduis, maxRaduis) *
                                    sin(angle)) +
                            origin;

                        hue = (angle % (2 * pi)) / (2 * pi); //0 to 1;

                        saturation =
                            raduis.clamp(-maxRaduis, maxRaduis) / (maxRaduis);
                      },
                      onPanEnd: (details) {
                        if (pickerExpanded) {
                          animationController.animateWith(SpringSimulation(
                              const SpringDescription(
                                  mass: 1, stiffness: 100, damping: 3),
                              1.0,
                              0.0,
                              -0.01));
                          pickerExpanded = false;
                        }
                      },
                      child: AnimatedBuilder(
                          animation: animationController,
                          child: RepaintBoundary(
                            child: Container(
                                height: heightpicker,
                                width: widthpicker,
                                alignment: Alignment.center,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    CustomPaint(
                                      painter: ColorPickerWidget(
                                          hue: hue,
                                          saturation: saturation * saturation),
                                      size: Size(widthpicker, heightpicker),
                                    ),
                                    const Align(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.amp_stories_rounded,
                                        color: Colors.black,
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          builder: (context, child) {
                            return Transform.scale(
                              scale: lerpDouble(
                                  1.0, 1.3, animationController.value),
                              child: child,
                            );
                          }),
                    ),
                  );
                },
              )
            ],
          ),
        ));
  }
}
