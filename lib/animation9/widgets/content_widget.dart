import 'package:flutter/material.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class ContentWidget extends StatelessWidget {
  const ContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final width = size.width;
    final fem = width / AppUtils.baseWidth;
    return Padding(
      padding: EdgeInsets.all(40 * fem),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Image.asset(
          'images/illustration2.png',
          height: width * 0.5,
          width: width * 0.5,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Easy paiement with Walletory',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17 * fem,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10 * fem,
              ),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15 * fem,
                ),
              ),
              SizedBox(
                height: 20 * fem,
              ),
              Row(
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        foregroundColor: Colors.blueGrey.shade700,
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      child: const Text('Login')),
                  SizedBox(
                    width: 20 * fem,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        foregroundColor: Colors.blueGrey.shade700,
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      child: const Text('Create Account'))
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }
}
