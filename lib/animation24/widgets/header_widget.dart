import 'package:flutter/material.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class HeaderWidget extends StatelessWidget {
  final Color color;
  const HeaderWidget({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    final double fem = width / AppUtils.baseWidth;
    final double gap = 10 * fem;
    final double heightText = 30 * fem;
    final double heightTitleText = 2 * 1.5 * 24 * fem;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: gap,
        ),
        SizedBox(
          height: heightText,
          child: FittedBox(
            child: Text(
              'Welcome to me',
              style: TextStyle(color: Colors.blueGrey.shade200),
            ),
          ),
        ),
        SizedBox(
          height: gap,
        ),
        SizedBox(
          height: heightTitleText,
          child: Text(
            'Choose the daily Animation',
            maxLines: 2,
            style: TextStyle(
                color: color,
                fontSize: 24 * fem,
                height: 1.5,
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
