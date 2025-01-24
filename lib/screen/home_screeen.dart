import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:get/get.dart';
import '../controller/timer_animation_controller.dart';

class HomeScreeen extends StatefulWidget {
  const HomeScreeen({super.key});

  @override
  State<HomeScreeen> createState() => _HomeScreeenState();
}

class _HomeScreeenState extends State<HomeScreeen> {
  var timerController = Get.find<TimerAnimationController>();
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
        body: Obx(() {
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
                    child: timerController.riveArtBoard == null
                        ? SizedBox()
                        : Rive(
                            artboard: timerController.riveArtBoard!,
                          ),
                  ),
                ),
                // Text
                Text(
                    'Current time: ${timerController.currentTimeInSeconds} second'),
                //  Add Timer Button
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              timerController.currentTimeInSeconds.value =
                                  int.parse(val);
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter time in seconds'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Done"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text("Add Timer"),
                ),
                //  Start Button
                TextButton(
                  onPressed: () {
                    timerController.start();
                  },
                  child: Text("Start"),
                ),

                //  Stop Button
                TextButton(
                  onPressed: () {
                    timerController.stop();
                  },
                  child: Text("Stop"),
                ),
              ],
            ),
          );
        }));
  }
}
