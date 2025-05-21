import 'package:flutter/material.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double fem = size.width / AppUtils.baseWidth;
    return Row(
      children: [
        Text(
          'Hello',
          style: TextStyle(color: Colors.indigo.shade900, fontSize: 24 * fem),
        ),
        SizedBox(
          width: 5 * fem,
        ),
        Text(
          'Elachhab',
          style: TextStyle(
              color: Colors.indigo.shade900,
              fontSize: 24 * fem,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
