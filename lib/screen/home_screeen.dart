import 'package:before_class_timer_app/controller/my_animation_controller.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import 'package:get/get.dart';

class HomeScreeen extends StatefulWidget {
  const HomeScreeen({super.key});

  @override
  State<HomeScreeen> createState() => _HomeScreeenState();
}

class _HomeScreeenState extends State<HomeScreeen> {
  final MyAnimationController myAnimationController =
      Get.find<MyAnimationController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'icon',
              child: Icon(
                Icons.alarm,
                size: 30,
                color: Colors.brown,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Timer Screen",
            ),
          ],
        ),
      ),
      body: Obx(
        () {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Rive
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    100,
                  ),
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: myAnimationController.riveArtBoard == null
                        ? SizedBox()
                        : Rive(
                            artboard: myAnimationController.riveArtBoard!,
                          ),
                  ),
                ),
                // Text
                Text(
                    'Current time: ${myAnimationController.currentTime.value} second'),
                //  Add Timer Button
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Add Timer"),
                            content: TextField(
                              onChanged: (value) {
                                myAnimationController.currentTime.value =
                                    int.tryParse(value) ?? 0;
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Enter time in second",
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Add"),
                              ),
                            ],
                          );
                        });
                  },
                  child: Text("Add Timer"),
                ),
                //  Start Button
                TextButton(
                  onPressed: () {
                    myAnimationController.startTime();
                  },
                  child: Text("Start"),
                ),

                //  Stop Button
                TextButton(
                  onPressed: () {
                    myAnimationController.stopAndResetTime();
                  },
                  child: Text("Stop"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
