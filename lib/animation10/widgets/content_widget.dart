import 'package:flutter/material.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class ContentWidget extends StatelessWidget {
  const ContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    final double fem = size.width / AppUtils.baseWidth;
    return Column(children: [
      ...List.generate(
          4,
          (index) => Container(
                width: width * 0.7,
                height: 20 * fem,
                margin: EdgeInsets.symmetric(vertical: 10 * fem),
                decoration: const BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15))),
              )),
    ]);
  }
}
