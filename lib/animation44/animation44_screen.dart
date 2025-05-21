import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation44/widgets/draggable_main_widget.dart';
import 'package:flutter_me_animations/models/word.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class Animation44Screen extends StatefulWidget {
  const Animation44Screen({super.key});

  @override
  State<Animation44Screen> createState() => _Animation44ScreenState();
}

class _Animation44ScreenState extends State<Animation44Screen>
    with TickerProviderStateMixin {
  final String translateds =
      "God exists even the void answers you with the echo";

  final List<String> untranslateds =
      "Dieu existe il méme le vide vous reponds par l'echo".split(' ');

  late List<Word> toTranslateds;

  final ValueNotifier<List<int>> attempteds = ValueNotifier([]);

  void onPanStart(int index) {}

  void onPanEnd(List<int> attempts) {
    attempteds.value = [...attempts];
  }

  final double padding = 10;

  final bgColor = const Color(0xFF111A14);

  @override
  void dispose() {
    attempteds.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final translatedArrays = translateds.split(' ');

    final shuffledTranslateArrays =
        List.generate(translatedArrays.length, (index) => index);

    shuffledTranslateArrays.shuffle();

    toTranslateds = translatedArrays
        .asMap()
        .entries
        .map((word) => Word(
            correctIndex: translatedArrays
                .asMap()
                .entries
                .where((sameWord) => sameWord.value == word.value)
                .map((word) => word.key)
                .toList(),
            index: shuffledTranslateArrays.indexOf(word.key),
            word: word.value))
        .sorted((a, b) => a.index.compareTo(b.index))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final fem = width / AppUtils.baseWidth;
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10 * fem,
            ),
            SizedBox(
              height: height * 0.25,
              child: Row(
                children: [
                  SizedBox(
                    width: 20 * fem,
                  ),
                  Transform.translate(
                    offset: Offset(0.0, height * 0.25 * 0.3),
                    child: Container(
                      width: 80 * fem,
                      height: height * 0.25,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        gradient: LinearGradient(
                            colors: [Color(0xFF84CC16), Color(0xFF365314)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 20 * fem,
                            child: const Icon(
                              Icons.flag,
                              color: Colors.white,
                            ),
                          ),
                          ValueListenableBuilder(
                              valueListenable: attempteds,
                              builder: (context, attempts, child) {
                                final percent = toTranslateds.fold(
                                        0.0,
                                        (prev, word) => word.correctIndex
                                                .contains(attempts
                                                    .indexOf(word.index))
                                            ? prev + 1
                                            : prev) /
                                    (toTranslateds.length);

                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15))),
                                  width: 20 * fem,
                                  height: lerpDouble(
                                      height * 0.25 * 0.3 + 20 * fem,
                                      height * 0.25 - 20 * fem,
                                      percent),
                                );
                              }),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10 * fem,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Spacer(),
                        Text(
                          'Translate This Sentence',
                          style: TextStyle(
                              color: Colors.white, fontSize: 24 * fem),
                        ),
                        SizedBox(
                          height: 5 * fem,
                        ),
                        Wrap(
                          runSpacing: 10 * fem,
                          spacing: 10 * fem,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          alignment: WrapAlignment.start,
                          runAlignment: WrapAlignment.start,
                          children: [
                            ...untranslateds.map((word) => Stack(
                                  children: [
                                    Text(
                                      word,
                                      style: const TextStyle(
                                          color: Colors.white70),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.bottomCenter +
                                            const Alignment(0.0, 0.5),
                                        child: Container(
                                          height: 4,
                                          decoration: BoxDecoration(
                                              color: const Color(0xFF8B5CF6),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 40 * fem,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: DraggableMainWidget(
                vsync: this,
                spacing: 10,
                padding: padding,
                totalWords: toTranslateds.length,
                onPanEnd: onPanEnd,
                onPanStart: onPanStart,
                children: toTranslateds
                    .map(
                      (word) => RepaintBoundary(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              CountryFlag.fromCountryCode(
                                'GB',
                                width: 20,
                                height: 15,
                                shape: const RoundedRectangle(4),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                word.word,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14 * fem,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: 5 * fem,
                              ),
                              ValueListenableBuilder(
                                  valueListenable: attempteds,
                                  builder: (context, attempts, child) {
                                    return CircleAvatar(
                                      backgroundColor: (word.correctIndex
                                                  .contains(attempts
                                                      .indexOf(word.index)) ||
                                              (!attempts.contains(word.index) &&
                                                  word.correctIndex
                                                      .contains(word.index)))
                                          ? Colors.green
                                          : Colors.red,
                                      radius: 5,
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
