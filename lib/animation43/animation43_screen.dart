import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_me_animations/animation43/widgets/mydraggableflex_widget.dart';
import 'package:flutter_me_animations/models/task.dart';
import 'package:faker/faker.dart' as fake;

class Animation43Screen extends StatefulWidget {
  const Animation43Screen({super.key});

  @override
  State<Animation43Screen> createState() => _Animation43ScreenState();
}

class _Animation43ScreenState extends State<Animation43Screen>
    with TickerProviderStateMixin {
  final List<Task> tasks = List.generate(12, (index) {
    var faker = fake.Faker();

    return Task(
        color: Color.fromRGBO(Random().nextInt(255), Random().nextInt(255),
            Random().nextInt(255), 1.0),
        count: Random().nextInt(10),
        name: faker.conference.name().substring(0, Random().nextInt(15) + 5));
  });

  int? dragIndex;

  bool isDragging = false;

  void onPanStart(index) {}

  void onPanEnd() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Manage Your task',
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
            ),
            Expanded(
              child: MydraggableFlexWidget(
                vsync: this,
                spacing: 10,
                totalTask: tasks.length,
                onPanEnd: onPanEnd,
                onPanStart: onPanStart,
                children: tasks
                    .map(
                      (task) => RepaintBoundary(
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: task.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: task.color, width: 2.0),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black,
                                    spreadRadius: 1.0,
                                    blurRadius: 0.5)
                              ]),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                  backgroundColor: task.color,
                                  radius: 10,
                                  child: Text(
                                    task.count.toString(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  )),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                task.name,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
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
