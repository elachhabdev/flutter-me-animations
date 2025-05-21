import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DoubleCircleSliderWidget extends LeafRenderObjectWidget {
  final TickerProvider vsync;
  const DoubleCircleSliderWidget({super.key, required this.vsync});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return DoubleCircleSliderRender(vsync: vsync);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {}
}

class SliderParentData extends ContainerBoxParentData<RenderBox> {
  bool isDragging = false;
}

class DoubleCircleSliderRender extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, SliderParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, SliderParentData> {
  final PanGestureRecognizer _panGestureRecognizer = PanGestureRecognizer();

  ui.Picture? picture;

  double startAngle = 0.0;

  double endAngle = 0.0;

  double arcAngle = 0.0;

  int currentSelectedScrub = -1; //0 start 1 end 2 arc

  Offset scrubStartPosition = Offset.zero;

  Offset scrubEndPosition = Offset.zero;

  Offset scrubArcPosition = Offset.zero;

  Offset deltaStartScrub = Offset.zero;

  Offset deltaEndScrub = Offset.zero;

  double startArcAngle = 0.0;

  double endArcAngle = 0.0;

  double radius = 0.0;

  final double scrubArc = 50;

  bool angleInsideArc(
    double angle,
    double startAngle,
    double sweepAngle,
  ) {
    angle = (angle + (2 * pi)) % (2 * pi);
    startAngle = (startAngle + (2 * pi)) % (2 * pi);
    double endAngle = (startAngle + sweepAngle) % (2 * pi);

    if (startAngle < endAngle) {
      return angle >= startAngle && angle <= endAngle;
    } else {
      return angle >= startAngle || angle <= endAngle;
    }
  }

  String convertAngleToTimeString(double angle) {
    double totalMinutes = ui.lerpDouble(0, 24 * 60, angle / 360)!;
    int hours = (totalMinutes ~/ 60) % 24;
    int minutes = (totalMinutes % 60).toInt();

    String formattedTime =
        '${hours.toString().padLeft(2, '0')}h  ${minutes.toString().padLeft(2, '0')}m';

    return formattedTime;
  }

  DoubleCircleSliderRender({required vsync}) {
    _panGestureRecognizer
      ..onStart = (details) {
        deltaStartScrub = details.localPosition - scrubStartPosition;
        deltaEndScrub = details.localPosition - scrubEndPosition;
        markNeedsPaint();

        if (currentSelectedScrub == 2) {
          final position = details.localPosition -
              Offset(constraints.maxWidth * 0.5, constraints.maxHeight * 0.5);

          startArcAngle = atan2(position.dy, position.dx);

          startArcAngle =
              (startArcAngle < 0.0 ? 2 * pi + startArcAngle : startArcAngle);
        }
      }
      ..onUpdate = (details) {
        final Offset center =
            Offset(constraints.maxWidth * 0.5, constraints.maxHeight * 0.5);

        if (currentSelectedScrub == 1) {
          final Offset position =
              details.localPosition - deltaEndScrub - center;

          endAngle = atan2(position.dy, position.dx);

          endAngle = (endAngle < 0.0 ? 2 * pi + endAngle : endAngle) - arcAngle;

          endAngle = endAngle % (2 * pi);

          endAngle = (endAngle < 0.0 ? 2 * pi + endAngle : endAngle);

          scrubEndPosition = Offset(radius * cos(endAngle + arcAngle),
                  radius * sin(endAngle + arcAngle)) +
              center;

          markNeedsPaint();
        } else if (currentSelectedScrub == 0) {
          final Offset position =
              details.localPosition - deltaStartScrub - center;

          startAngle = atan2(position.dy, position.dx);

          startAngle =
              (startAngle < 0.0 ? 2 * pi + startAngle : startAngle) - arcAngle;

          startAngle = startAngle % (2 * pi);

          startAngle = (startAngle < 0.0 ? 2 * pi + startAngle : startAngle);

          scrubStartPosition = Offset(radius * cos(startAngle + arcAngle),
                  radius * sin(startAngle + arcAngle)) +
              center;

          markNeedsPaint();
        } else if (currentSelectedScrub == 2) {
          final Offset position = details.localPosition - center;

          arcAngle = atan2(position.dy, position.dx);

          arcAngle = (arcAngle < 0.0 ? 2 * pi + arcAngle : arcAngle) +
              endArcAngle -
              startArcAngle;

          arcAngle = arcAngle % (2 * pi);

          arcAngle = (arcAngle < 0.0 ? 2 * pi + arcAngle : arcAngle);

          scrubStartPosition = Offset(radius * cos(startAngle + arcAngle),
                  radius * sin(startAngle + arcAngle)) +
              center;

          scrubEndPosition = Offset(radius * cos(endAngle + arcAngle),
                  radius * sin(endAngle + arcAngle)) +
              center;

          markNeedsPaint();
        }
      }
      ..onEnd = (details) {
        if (currentSelectedScrub == 2) {
          endArcAngle = arcAngle;
        }
      };
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void detach() {
    _panGestureRecognizer.dispose();
    super.detach();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! SliderParentData) {
      child.parentData = SliderParentData();
    }
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      _panGestureRecognizer.addPointer(event);
    }
  }

  @override
  void performLayout() {
    radius = constraints.maxWidth * 0.8 * 0.5;
    scrubStartPosition = Offset(
        constraints.maxWidth * 0.5 + radius, constraints.maxHeight * 0.5);
    scrubEndPosition = Offset(
        constraints.maxWidth * 0.5 - radius, constraints.maxHeight * 0.5);

    startAngle = 0.0;
    endAngle = pi;
    size = Size(constraints.maxWidth, constraints.maxHeight);
  }

  String totalSleeped(double anglestart, double angleend) {
    final convertedTimes = ui.lerpDouble(0, 24 * 60, anglestart / 360)!;
    final convertedTimee = ui.lerpDouble(0, 24 * 60, angleend / 360)!;

    int differenceMinutes = (convertedTimee - convertedTimes).toInt();
    if (differenceMinutes < 0) {
      differenceMinutes +=
          1440; // Adjust for negative differences (if time crosses midnight)
    }

    int hours = (differenceMinutes ~/ 60) % 24; // Hours in 24-hour format
    int minutes = differenceMinutes % 60; // Minutes remaining

    // Format the time difference as HH:MM
    String formattedDifference =
        '${hours.toString().padLeft(2, '0')} h ${minutes.toString().padLeft(2, '0')}m';

    return formattedDifference;
  }

  @override
  bool hitTest(BoxHitTestResult result, {required ui.Offset position}) {
    final translateCenter = Alignment.center.alongSize(size);

    final Matrix4 matrix4Transformed = Matrix4.identity()
      ..translate(translateCenter.dx, translateCenter.dy)
      ..rotateZ(arcAngle)
      ..translate(-translateCenter.dx, -translateCenter.dy);

    final Matrix4? inverseMatrixTransformed =
        Matrix4.tryInvert(matrix4Transformed);

    if ((position - scrubEndPosition).distance <= scrubArc * 0.8 * 0.5) {
      result.add(BoxHitTestEntry(this, position));
      currentSelectedScrub = 1;
      return true;
    } else if ((position - scrubStartPosition).distance <=
        scrubArc * 0.8 * 0.5) {
      result.add(BoxHitTestEntry(this, position));
      currentSelectedScrub = 0;
      return true;
    } else if (inverseMatrixTransformed != null) {
      final transformedPoint =
          MatrixUtils.transformPoint(inverseMatrixTransformed, position);

      final center =
          Offset(constraints.maxWidth * 0.5, constraints.maxHeight * 0.5);

      //circle inner and circle outer to check between them ring

      const double sensitivity = 10.0;

      final circleOuter = Path()
        ..addOval(Rect.fromCircle(
            center: center, radius: radius + scrubArc * 0.5 + sensitivity));

      final circleInner = Path()
        ..addOval(Rect.fromCircle(
            center: center, radius: radius - scrubArc * 0.5 - sensitivity));

      final pointFromCenter = (transformedPoint - center);

      final transformedAngle = atan2(pointFromCenter.dy, pointFromCenter.dx);

      double angle = (transformedAngle < 0.0
          ? 2 * pi + transformedAngle
          : transformedAngle);

      if (circleOuter.contains(transformedPoint) &&
          !circleInner.contains(transformedPoint) &&
          angleInsideArc(
              angle,
              startAngle,
              (startAngle > endAngle
                  ? 2 * pi - (startAngle - endAngle)
                  : endAngle - startAngle))) {
        result.add(BoxHitTestEntry(this, position));

        currentSelectedScrub = 2;

        return true;
      }

      return false;
    } else {
      currentSelectedScrub = -1;
      return false;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final center =
        Offset(constraints.maxWidth * 0.5, constraints.maxHeight * 0.5);

    if (picture == null) {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      final paint2 = Paint()
        ..color = Colors.white
        ..strokeWidth = scrubArc
        ..style = PaintingStyle.stroke;

      canvas.drawArc(
          Rect.fromLTWH(
              center.dx - radius, center.dy - radius, radius * 2, radius * 2),
          0.0,
          2 * pi,
          false,
          paint2);

      final paint4 = Paint()..color = Colors.grey.shade900;

      final paint5 = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..color = Colors.grey.shade800;

      final paint6 = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..color = Colors.white;

      canvas.drawCircle(center, radius * 0.7, paint4);

      for (int i = 0; i < 360; i += 6) {
        double angleTodeg = 2 * pi * (180 / pi);

        final x = radius * cos(i * pi / 180);
        final y = radius * sin(i * pi / 180);

        if (i <= angleTodeg) {
          final xOut = x * 0.6 + center.dx;
          final yOut = y * 0.6 + center.dy;

          final xIn = xOut - x * 0.1;
          final yIn = yOut - y * 0.1;

          final path = Path()
            ..moveTo(xOut, yOut)
            ..lineTo(xIn, yIn);

          canvas.drawPath(path, paint6);
        }
      }

      for (int i = 0; i < 360; i += 30) {
        double angleTodeg = 2 * pi * (180 / pi);
        final x = radius * cos(i * pi / 180);
        final y = radius * sin(i * pi / 180);

        if (i <= angleTodeg) {
          final xOut = x * 0.65 + center.dx;
          final yOut = y * 0.65 + center.dy;

          final xIn = xOut - x * 0.15;
          final yIn = yOut - y * 0.15;

          final path = Path()
            ..moveTo(xOut, yOut)
            ..lineTo(xIn, yIn);

          canvas.drawPath(path, paint5);
        }
      }

      picture = recorder.endRecording();

      context.canvas.drawPicture(picture!);
    } else {
      context.canvas.drawPicture(picture!);
    }

    final canvas = context.canvas;

    //draw arc masked

    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = scrubArc * 0.8
      ..style = PaintingStyle.stroke;

    //Mask
    final maskPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = scrubArc * 0.8
      ..color = Colors.black;

    final arcPath = Path()
      ..addArc(
          Rect.fromLTWH(
              center.dx - radius, center.dy - radius, radius * 2, radius * 2),
          startAngle,
          (startAngle > endAngle
              ? 2 * pi - (startAngle - endAngle)
              : endAngle - startAngle));

    canvas.saveLayer(
        Rect.fromLTWH(
            center.dx - radius - scrubArc,
            center.dy - radius - scrubArc,
            radius * 2 + 2 * scrubArc,
            radius * 2 + 2 * scrubArc),
        Paint());
    final translateCenter = Alignment.center.alongSize(size);

    canvas.translate(translateCenter.dx, translateCenter.dy);
    canvas.rotate(arcAngle);
    canvas.translate(-translateCenter.dx, -translateCenter.dy);

    canvas.drawPath(arcPath, maskPaint);

    //draw inside mask

    canvas.drawPath(arcPath, paint);

    final paint3 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = Colors.white
      ..blendMode = BlendMode.srcIn;

    for (int i = 0; i < 360; i += 3) {
      double angleTodeg = 2 * pi * (180 / pi);
      final x = radius * cos(i * pi / 180);
      final y = radius * sin(i * pi / 180);

      if (i <= angleTodeg) {
        final xOut = x * 0.95 + center.dx;
        final yOut = y * 0.95 + center.dy;

        final xIn = xOut + x * 0.1;
        final yIn = yOut + y * 0.1;

        final path = Path()
          ..moveTo(xOut, yOut)
          ..lineTo(xIn, yIn);

        canvas.drawPath(path, paint3);
      }
    }

    canvas.restore();

    final startScrubPaint = Paint()..color = Colors.green.shade300;

    canvas.drawCircle(
        scrubStartPosition, scrubArc * 0.8 * 0.5, startScrubPaint);

    final startIcon = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(Icons.bed.codePoint),
          style: TextStyle(
              color: Colors.white,
              fontFamily: Icons.bed.fontFamily,
              package: Icons.bed.fontPackage,
              fontSize: 22),
        ),
        textDirection: TextDirection.ltr);

    startIcon.layout();

    startIcon.paint(
        canvas,
        Offset(scrubStartPosition.dx - startIcon.width * 0.5,
            scrubStartPosition.dy - startIcon.height * 0.5));

    final endScrubPaint = Paint()..color = Colors.green.shade300;

    canvas.drawCircle(scrubEndPosition, scrubArc * 0.8 * 0.5, endScrubPaint);

    final endIcon = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(Icons.alarm.codePoint),
          style: TextStyle(
              color: Colors.white,
              fontFamily: Icons.alarm.fontFamily,
              package: Icons.alarm.fontPackage,
              fontSize: 22),
        ),
        textDirection: TextDirection.ltr);

    endIcon.layout();

    endIcon.paint(
        canvas,
        Offset(scrubEndPosition.dx - endIcon.width * 0.5,
            scrubEndPosition.dy - endIcon.height * 0.5));

    final textSleeped = TextPainter(
        text: TextSpan(
          children: [
            TextSpan(
                text: totalSleeped(startAngle * 180 / pi, endAngle * 180 / pi),
                style: const TextStyle(color: Colors.white70, fontSize: 16)),
          ],
        ),
        textDirection: TextDirection.ltr);

    textSleeped.layout();

    textSleeped.paint(
        canvas,
        Offset(center.dx - textSleeped.width * 0.5,
            center.dy - textSleeped.height * 0.5));

    final textHoursSleeped = TextPainter(
        text: const TextSpan(
          children: [
            TextSpan(
                text: 'Total Sleeped',
                style: TextStyle(color: Colors.green, fontSize: 12)),
          ],
        ),
        textDirection: TextDirection.ltr);

    textHoursSleeped.layout();

    textHoursSleeped.paint(
        canvas,
        Offset(center.dx + 15 - textHoursSleeped.width * 0.5,
            center.dy + 15 - textHoursSleeped.height * 0.5));

    final sleepat = TextPainter(
        text: const TextSpan(
          children: [
            TextSpan(
                text: 'sleep at',
                style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
        textDirection: TextDirection.ltr);

    sleepat.layout();

    sleepat.paint(
        canvas,
        Offset(center.dx + 5 - sleepat.width * 0.5,
            center.dy - 30 - sleepat.height * 0.5));

    final sleep = TextPainter(
        text: TextSpan(
          children: [
            TextSpan(
                text: convertAngleToTimeString(
                    (startAngle + arcAngle) * 180 / pi),
                style: const TextStyle(color: Colors.green, fontSize: 12)),
          ],
        ),
        textDirection: TextDirection.ltr);

    sleep.layout();

    sleep.paint(
        canvas,
        Offset(center.dx + 10 - sleep.width * 0.5,
            center.dy - 45 - sleepat.height * 0.5));

    final wakeat = TextPainter(
        text: const TextSpan(
          children: [
            TextSpan(
                text: 'Wake at',
                style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
        textDirection: TextDirection.ltr);

    wakeat.layout();

    wakeat.paint(
        canvas,
        Offset(center.dx + 5 - wakeat.width * 0.5,
            center.dy + 40 - wakeat.height * 0.5));

    final wake = TextPainter(
        text: TextSpan(
          children: [
            TextSpan(
                text:
                    convertAngleToTimeString((endAngle + arcAngle) * 180 / pi),
                style: const TextStyle(color: Colors.green, fontSize: 12)),
          ],
        ),
        textDirection: TextDirection.ltr);

    wake.layout();

    wake.paint(
        canvas,
        Offset(center.dx + 10 - wake.width * 0.5,
            center.dy + 55 - wakeat.height * 0.5));
  }
}
