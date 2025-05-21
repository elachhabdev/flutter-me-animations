import 'package:flutter/material.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final fem = width / AppUtils.baseWidth;
    return Container(
        color: Colors.blueGrey.shade900,
        padding: EdgeInsets.symmetric(horizontal: 25 * fem, vertical: 10 * fem),
        child: Column(
          children: [
            SizedBox(
              height: 20 * fem,
            ),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ',
              style: TextStyle(color: Colors.white70, fontSize: 15 * fem),
            ),
            SizedBox(
              height: 30 * fem,
            ),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ',
              style: TextStyle(color: Colors.white70, fontSize: 15 * fem),
            ),
            SizedBox(
              height: 30 * fem,
            ),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ',
              style: TextStyle(color: Colors.white70, fontSize: 15 * fem),
            ),
          ],
        ));
  }
}
