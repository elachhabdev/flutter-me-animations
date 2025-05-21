import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<int> animations = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 50; i++) {
      if (i == 7 || i == 10 || i == 21) {
        continue;
      } else {
        animations.add(i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: ListView.builder(
          itemCount: animations.length,
          itemBuilder: (context, index) => ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
                backgroundColor: Colors.green),
            onPressed: () => Navigator.of(context)
                .pushNamed('animation${animations[index] + 1}'),
            child: Text(
              'animation me ${animations[index] + 1}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
