import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class ContainerWidget extends StatefulWidget {
  final int index;
  final int totalChildrens;
  final Color color;
  final String title;
  final Function updateCurrentColor;

  const ContainerWidget({
    super.key,
    required this.index,
    required this.totalChildrens,
    required this.color,
    required this.title,
    required this.updateCurrentColor,
  });

  @override
  State<ContainerWidget> createState() => _ContainerWidgetState();
}

class _ContainerWidgetState extends State<ContainerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  Timer? timer;

  bool isExpanded = false;

  reverseanimation(status) {
    if (status == AnimationStatus.completed) {
      timer?.cancel();
      timer = Timer(const Duration(milliseconds: 800), () {
        if (mounted) {
          animationController
              .fling(
                  velocity: -0.01,
                  springDescription: SpringDescription.withDampingRatio(
                    mass: 1.0,
                    stiffness: 1000.0,
                    ratio: 2.2,
                  ))
              .whenCompleteOrCancel(() {
            isExpanded = false;
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this);
    animationController.addStatusListener(reverseanimation);
  }

  @override
  void dispose() {
    timer?.cancel();
    animationController.removeStatusListener(reverseanimation);
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    final double fem = width / AppUtils.baseWidth;
    return Positioned.fill(
      child: GestureDetector(
          onTap: () {
            if (isExpanded) {
              return;
            }

            isExpanded = true;

            widget.updateCurrentColor(widget.color, widget.index);

            animationController.fling(
                velocity: 0.01,
                springDescription: SpringDescription.withDampingRatio(
                  mass: 1.0,
                  stiffness: 1000.0,
                  ratio: 2.2,
                ));
          },
          child: AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: lerpDouble(1.0, 1.1, animationController.value),
                child: FractionallySizedBox(
                  widthFactor: lerpDouble(1 / widget.totalChildrens, 1.0,
                      animationController.value),
                  heightFactor: lerpDouble(0.8, 1.0, animationController.value),
                  alignment: Alignment.lerp(
                      Alignment.centerLeft,
                      Alignment.centerRight,
                      widget.index / (widget.totalChildrens - 1))!,
                  child: Container(
                    padding: EdgeInsets.all(10 * fem),
                    margin: EdgeInsets.symmetric(horizontal: 5 * fem),
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Visibility(
                        visible: isExpanded && animationController.isCompleted
                            ? true
                            : false,
                        child: child!),
                  ),
                ),
              );
            },
            child: buildContent(fem),
          )),
    );
  }

  Widget buildContent(double fem) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Elachhab Mohammed',
            style: TextStyle(color: Colors.white70, fontSize: 14 * fem),
          ),
          Text(widget.title,
              style: TextStyle(color: Colors.white70, fontSize: 14 * fem))
        ]);
  }
}
