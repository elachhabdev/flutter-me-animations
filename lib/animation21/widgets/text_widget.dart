import 'package:flutter/material.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class TextWidget extends StatelessWidget {
  final double contentHeight;
  final double contentWidth;
  final double pagePercent;
  final int day;
  final String dayTitle;

  const TextWidget({
    super.key,
    required this.contentHeight,
    required this.contentWidth,
    required this.pagePercent,
    required this.day,
    required this.dayTitle,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final fem = width / AppUtils.baseWidth;
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(horizontal: 5 * fem),
      child: Row(
        spacing: 2 * fem,
        children: [
          Icon(
            Icons.timelapse,
            color: Color.lerp(
              Colors.purple.shade300,
              Colors.white54,
              (pagePercent).abs().clamp(0.0, 1.0),
            ),
          ),
          SizedBox(
            height: contentHeight * 0.5,
            child: FittedBox(
              child: Text(
                '$day',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color.lerp(
                    Colors.white,
                    Colors.white54,
                    (pagePercent).abs().clamp(0.0, 1.0),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: contentHeight * 0.5,
            child: FittedBox(
              child: Text(
                dayTitle,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color.lerp(
                    Colors.white,
                    Colors.white54,
                    (pagePercent).abs().clamp(0.0, 1.0),
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
