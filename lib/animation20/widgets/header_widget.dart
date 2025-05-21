import 'package:flutter/material.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final fem = width / AppUtils.baseWidth;

    return Expanded(
        child: Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.all(30 * fem),
        height: 36 * fem * 1.5 * 2,
        child: Text(
          'Here is your task list for today',
          maxLines: 2,
          style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w300,
              fontSize: 36 * fem,
              height: 1.5,
              overflow: TextOverflow.ellipsis),
        ),
      ),
    ));
  }
}
