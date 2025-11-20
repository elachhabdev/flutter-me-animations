import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:faker/faker.dart' as fake;

class MyCircleList extends SliverMultiBoxAdaptorWidget {
  const MyCircleList({super.key, required super.delegate});

  @override
  SliverMultiBoxAdaptorElement createElement() =>
      SliverMultiBoxAdaptorElement(this, replaceMovedChildren: true);

  @override
  MyRenderSliver createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element =
        context as SliverMultiBoxAdaptorElement;
    return MyRenderSliver(childManager: element);
  }
}

class MyRenderSliver extends RenderSliverList {
  MyRenderSliver({required super.childManager});

  double maxChildWidth = 0;

  @override
  void performLayout() {
    double maxPaintExtent = 0;

    childManager.didStartLayout();
    childManager.setDidUnderflow(false);

    if (firstChild == null) {
      addInitialChild();
    }

    RenderBox? child = firstChild;

    double childMainAxisPosition = 0.0;

    int index = 0;

    while (child != null) {
      final SliverMultiBoxAdaptorParentData childParentData =
          child.parentData as SliverMultiBoxAdaptorParentData;

      child.layout(BoxConstraints.tightFor(), parentUsesSize: true);

      childMainAxisPosition = child.size.height;

      maxChildWidth = max(maxChildWidth, child.size.width);

      childParentData.layoutOffset = childMainAxisPosition * index;

      child = childAfter(child);

      child ??= insertAndLayoutChild(
        constraints.asBoxConstraints(),
        after: lastChild,
      );

      index++;
    }

    maxPaintExtent =
        constraints.viewportMainAxisExtent / 2 * 2 * pi; //approximation circle

    /*  double visibleExtent = (maxPaintExtent - constraints.scrollOffset).clamp(
      0.0,
      constraints.remainingPaintExtent,
    ); */

    final double visibleExtent = calculatePaintOffset(
      constraints,
      from: childScrollOffset(firstChild!)!,
      to: maxPaintExtent,
    );

    geometry = SliverGeometry(
      scrollExtent: maxPaintExtent,
      paintExtent: visibleExtent,
      maxPaintExtent: maxPaintExtent,
    );

    childManager.didFinishLayout();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;

    int index = 0;

    final totalExtent = constraints.viewportMainAxisExtent;

    final gap = 60;

    final maxWidth = min(500, constraints.crossAxisExtent);

    final b = totalExtent / 1.3;

    final a = maxWidth - maxChildWidth - gap;

    final barPaint = Paint()..color = Colors.yellow;

    final circlePaint = Paint()..color = Colors.amber.shade700;

    context.canvas.drawCircle(Offset(40, totalExtent / 2), 10, circlePaint);

    while (child != null) {
      final double effectiveScrollOffset =
          constraints.scrollOffset + constraints.overlap;

      final angelScrolled = lerpDouble(
        0,
        2 * pi,
        effectiveScrollOffset / (geometry!.scrollExtent - totalExtent),
      )!;

      final angle = lerpDouble(0, 2 * pi, index / childCount)! - angelScrolled;

      final currentIndex = lerpDouble(
        0,
        childCount,
        effectiveScrollOffset / (geometry!.scrollExtent - totalExtent),
      )!;

      // final percent = (1 - (index - currentIndex!).abs()).clamp(0.0, 1.0);

      final calculatedOffset = Offset(
        a * cos(angle),
        totalExtent / 2 + b * sin(angle) - child.size.height / 2,
      );

      context.pushTransform(
        needsCompositing,
        calculatedOffset,
        Matrix4.identity()
          ..translate(0.0, child.size.height / 2)
          ..rotateZ(angle)
          ..translate(0.0, -child.size.height / 2),

        (context, offset) {
          final fillWidth =
              child!.size.width * ((currentIndex - index)).clamp(0.0, 1.0);

          context.canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(
                offset.dx,
                offset.dy - child.size.height / 2,
                fillWidth,
                child.size.height / 2,
              ),
              Radius.circular(10),
            ),
            barPaint,
          );

          context.paintChild(child, offset);
        },
      );

      child = childAfter(child);

      index++;
    }
  }
}

class Animation51Screen extends StatefulWidget {
  const Animation51Screen({super.key});

  @override
  State<Animation51Screen> createState() => _Animation51ScreenState();
}

class _Animation51ScreenState extends State<Animation51Screen> {
  @override
  Widget build(BuildContext context) {
    final List<String> names = List.generate(60, (index) {
      var faker = fake.Faker();

      return "${faker.person.firstName()} ${faker.person.lastName()}";
    });

    return Scaffold(
      backgroundColor: Colors.yellow.shade50,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          MyCircleList(
            delegate: SliverChildBuilderDelegate(childCount: 60, (
              context,
              index,
            ) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  names[index],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
