import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation30/widgets/custom_header.dart';
import 'package:flutter_me_animations/animation30/widgets/nom_widget.dart';
import 'package:flutter_me_animations/models/nom.dart';
import 'package:flutter_me_animations/utils/app_utils.dart';

class Animation30Screen extends StatefulWidget {
  const Animation30Screen({super.key});

  @override
  State<Animation30Screen> createState() => _Animation30ScreenState();
}

class _Animation30ScreenState extends State<Animation30Screen> {
  late ScrollController scrollController;

  final ValueNotifier<double> page = ValueNotifier(0.0);

  final List<String> images =
      List.generate(9, (index) => 'images/avatar-${index + 1}.jpg');

  final List<String> alphabets =
      List.generate(26, (index) => String.fromCharCode(index + 65));

  late double width;

  late double height;

  late double fem;

  late double containerHeight;

  late double containerWidth;

  late double topPadding;

  late double boxHeight;

  late double gap;

  late int numberofNomVisible;

  final int totalstickedalpahebets = 3;

  final List<Nom> noms = [];

  List<Nom> stickedList = [];

  final Map<int, List<Nom>> cachedStickedList = {};

  final ValueNotifier<int> currentindex = ValueNotifier(0);

  int prevPage = -1;

  setupNoms() {
    int index = 0;
    for (var alphabet in alphabets) {
      int random = Random().nextInt(9);

      noms.addAll(List.generate(random + 1, (index) => index)
          .asMap()
          .entries
          .map((e) => Nom(
              index: index + e.key,
              image: images[Random().nextInt(9)],
              isalphabet: e.key == 0,
              alphabet: alphabet,
              nom: e.key == 0 ? alphabet : '${alphabet}nom${e.value}',
              prenom: e.key == 0 ? '' : '${e.value}prenom$alphabet'))
          .toList());
      index += random + 1;
    }
  }

  scrolllistener() {
    final containerAfterBox = boxHeight - (containerHeight + topPadding);
    if (scrollController.offset > containerAfterBox) {
      page.value =
          (scrollController.offset - containerAfterBox) / (containerHeight);
      if (prevPage != page.value.floor()) {
        updateStickedList(page.value.floor());
        prevPage = page.value.floor();
      }
    }
  }

  updateStickedList(index) {
    currentindex.value = index;

    List<Nom> stickedListTochange = noms.sublist(0, currentindex.value);

    if (stickedListTochange.length <= numberofNomVisible) {
      stickedList = stickedListTochange;
    } else {
      if (cachedStickedList.containsKey(currentindex.value)) {
        stickedList = cachedStickedList[currentindex.value]!;
      } else {
        while (stickedListTochange.length > numberofNomVisible) {
          int howmanystickedalphabets = 0;

          int startindexalphabet = 0;

          //get sticked alphabet that have children quick loop

          Nom? stickedalphabet;

          for (var i = 0; i < numberofNomVisible; i++) {
            if (stickedListTochange[i].isalphabet) {
              stickedalphabet = stickedListTochange[i];
            } else {
              if (stickedalphabet != null) {
                break;
              }
            }
          }

          //how many sticked alphabets quick loop

          for (var i = 1; i < numberofNomVisible; i++) {
            if (stickedListTochange[i].isalphabet &&
                stickedListTochange[i - 1].isalphabet) {
              howmanystickedalphabets++;
              if (howmanystickedalphabets >= totalstickedalpahebets) {
                break;
              }
            }
          }

          //index sticked alphabets quick loop

          for (var i = 0; i < numberofNomVisible; i++) {
            if (stickedListTochange[i].isalphabet &&
                stickedListTochange[i].alphabet == stickedalphabet!.alphabet) {
              startindexalphabet = i;
              break;
            }
          }

          //if sticked alphabets become bigger than desired first sticked alphabet
          //should go otherwise keep and shift

          if (howmanystickedalphabets >= totalstickedalpahebets) {
            for (int j = 0; j < stickedListTochange.length - 1; j++) {
              Nom temp = stickedListTochange[j];
              stickedListTochange[j] = stickedListTochange[j + 1];
              stickedListTochange[j + 1] = temp;
            }
          } else {
            for (int j = 0; j < stickedListTochange.length - 1; j++) {
              if (j <= startindexalphabet) {
                continue;
              } else {
                Nom temp = stickedListTochange[j];
                stickedListTochange[j] = stickedListTochange[j + 1];
                stickedListTochange[j + 1] = temp;
              }
            }
          }

          //can even optimized by caching from starting to currentindex but this not the purpose

          stickedListTochange.removeLast();
          stickedList = stickedListTochange;
          cachedStickedList.putIfAbsent(currentindex.value, () => stickedList);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setupNoms();
    scrollController = ScrollController();
    scrollController.addListener(scrolllistener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Size size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    fem = width / AppUtils.baseWidth;
    containerHeight = 80 * fem;
    containerWidth = 40 * fem;
    topPadding = MediaQuery.of(context).viewPadding.top;
    gap = 5 * fem;
    numberofNomVisible = (width / (containerWidth + 2 * gap)).floor();
    boxHeight = 250 * fem;
  }

  @override
  void dispose() {
    currentindex.dispose();
    scrollController.removeListener(scrolllistener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            CustomScrollView(controller: scrollController, slivers: [
              SliverPersistentHeader(
                delegate: CustomHeader(boxHeight: boxHeight),
              ),
              SliverList.builder(
                  itemCount: noms.length,
                  itemBuilder: (context, index) => NomWidget(
                      nom: noms[index],
                      containerHeight: containerHeight,
                      fem: fem)),
            ]),
            Positioned(
                left: 0,
                top: 0,
                width: width,
                height: containerHeight + topPadding,
                child: AnimatedBuilder(
                    animation: scrollController,
                    builder: (context, child) {
                      final double scrollPercent = (scrollController.offset /
                              (boxHeight - containerHeight))
                          .clamp(0.0, 1.0);
                      return Transform.translate(
                        offset: Offset(
                            0.0,
                            lerpDouble(-containerHeight - topPadding, 0.0,
                                scrollPercent)!),
                        child: child,
                      );
                    },
                    child: Container(
                      color: Colors.grey.shade800,
                    ))),
            Positioned(
              left: 0,
              top: 0,
              width: width,
              height: containerHeight + topPadding,
              child: AnimatedBuilder(
                animation: scrollController,
                builder: (context, child) {
                  final double scrollPercent =
                      (scrollController.offset / (boxHeight - containerHeight))
                          .clamp(0.0, 1.0);
                  return Transform.translate(
                      offset: Offset(
                          0.0,
                          lerpDouble(-containerHeight - topPadding, 0.0,
                              scrollPercent)!),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(height: containerHeight, child: child),
                      ));
                },
                child: ValueListenableBuilder(
                    valueListenable: currentindex,
                    builder: (context, _, child) {
                      return ListView.builder(
                        itemCount: stickedList.length,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => !stickedList[index]
                                .isalphabet
                            ? Container(
                                key: ValueKey(index),
                                width: containerWidth,
                                height: containerWidth,
                                margin: EdgeInsets.symmetric(horizontal: gap),
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        containerWidth * 0.5),
                                    child:
                                        Image.asset(stickedList[index].image)),
                              )
                            : GestureDetector(
                                key: ValueKey(index),
                                onTap: () {
                                  double toscroll = stickedList[index].index *
                                      containerHeight;

                                  scrollController.jumpTo(
                                      toscroll < (height - boxHeight)
                                          ? 0.0
                                          : toscroll);
                                },
                                child: Container(
                                  width: containerWidth,
                                  height: containerWidth,
                                  margin: EdgeInsets.symmetric(horizontal: gap),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: (index < totalstickedalpahebets &&
                                              stickedList[index >= 1
                                                      ? index - 1
                                                      : 0]
                                                  .isalphabet)
                                          ? Colors.green
                                          : Colors.blue),
                                  child: Text(
                                      '${stickedList[index].nom.substring(0, 1)}${stickedList[index].isalphabet ? '' : stickedList[index].prenom.substring(0, 1)}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18 * fem)),
                                ),
                              ),
                      );
                    }),
              ),
            ),
          ],
        ));
  }
}
