import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation3/widgets/movie_item_widget.dart';
import 'package:flutter_me_animations/animation3/widgets/stack_movies_widget.dart';
import 'package:flutter_me_animations/models/movie.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class Animation3Screen extends StatefulWidget {
  const Animation3Screen({super.key});

  @override
  State<Animation3Screen> createState() => _Animation3ScreenState();
}

class _Animation3ScreenState extends State<Animation3Screen>
    with SingleTickerProviderStateMixin {
  final List<Movie> movies = const [
    Movie(index: 0, title: 'Pulp Fiction', image: 'movie1.jpg'),
    Movie(index: 1, title: 'GoodFellas', image: 'movie2.jpg'),
    Movie(index: 2, title: 'Shutter Island', image: 'movie3.jpg'),
    Movie(index: 3, title: 'Harry potter', image: 'movie4.jpg'),
  ];

  late PageController pageController;

  final ValueNotifier<double> page = ValueNotifier(0.0);

  pagestack() {
    page.value = pageController.page!;
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.65);
    pageController.addListener(pagestack);
  }

  @override
  void dispose() {
    pageController.removeListener(pagestack);
    page.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final width = size.width;
    final fem = width / AppUtils.baseWidth;
    final double gap = 10 * fem;

    return Scaffold(
      body: Stack(
        children: [
          StackMoviesWidget(movies: movies, page: page),
          Positioned.fill(
              bottom: 3 * gap,
              child: PageView.builder(
                  itemCount: movies.length,
                  scrollDirection: Axis.horizontal,
                  controller: pageController,
                  itemBuilder: (context, index) => MovieItemWidget(
                        movie: movies[index],
                        gap: gap,
                        index: index,
                        pageController: pageController,
                      ))),
          Positioned.fill(
              bottom: gap,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2 * gap, vertical: gap),
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: const Text(
                    'Pay Ticket',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
