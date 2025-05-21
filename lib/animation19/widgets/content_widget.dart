import 'package:flutter/material.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class ContentWidget extends StatelessWidget {
  const ContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final fem = width / AppUtils.baseWidth;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25 * fem, vertical: 10 * fem),
      child: Text(
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ',
        style: TextStyle(fontSize: 15 * fem, color: Colors.white70),
      ),
    );
  }
}
