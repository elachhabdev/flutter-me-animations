import 'package:flutter/material.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class ArticleWidget extends StatelessWidget {
  final int totalItems;
  final double maxHeight;

  const ArticleWidget(
      {super.key, required this.totalItems, required this.maxHeight});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;
    final fem = width / AppUtils.baseWidth;
    final padding = 10 * fem;
    final calculatedHeight = ((height - maxHeight) / totalItems);

    return RepaintBoundary(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 25 * fem,
        ),
        margin:
            EdgeInsets.only(left: 10 * fem, right: 10 * fem, bottom: 25 * fem),
        height: height * 0.8,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black38, spreadRadius: 0.5, blurRadius: 10.0)
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 10 * fem,
          ),
          SizedBox(
            height: calculatedHeight - padding,
            child: const FittedBox(
              child: Text(
                'The ranking of search\n engines Google',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 30 * fem,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Flutter',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 16 * fem)),
              Text('Flutter',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 16 * fem)),
              Text('Flutter',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 16 * fem))
            ],
          ),
          SizedBox(
            height: 30 * fem,
          ),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.',
            style: TextStyle(height: 1.4, fontSize: 14 * fem),
          ),
          SizedBox(
            height: 10 * fem,
          ),
          Text(
            'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
            style: TextStyle(height: 1.4, fontSize: 14 * fem),
          ),
          SizedBox(
            height: 10 * fem,
          ),
          Text(
            'sed do eiusmod tempor incididunt ut labore et dolore magna ',
            style: TextStyle(height: 1.4, fontSize: 14 * fem),
          ),
          const Spacer(),
          Chip(
            label: Text(
              'Read More',
              style: TextStyle(color: Colors.white, fontSize: 14 * fem),
            ),
            backgroundColor: Colors.black,
            labelPadding:
                EdgeInsets.symmetric(horizontal: 35 * fem, vertical: 5 * fem),
          ),
          SizedBox(
            height: 30 * fem,
          ),
        ]),
      ),
    );
  }
}
