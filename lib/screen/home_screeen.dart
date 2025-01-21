import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class HomeScreeen extends StatefulWidget {
  const HomeScreeen({super.key});

  @override
  State<HomeScreeen> createState() => _HomeScreeenState();
}

class _HomeScreeenState extends State<HomeScreeen> {
  Artboard? _riveArtboard;
  SMIBool? _startTrigger;
  SMITrigger? _shakeTrigger;
  Future<void> _initializeRive() async {
    await RiveFile.initialize();
    await loadRiveFile();
  }

  Future<void> loadRiveFile() async {
    var data = await rootBundle.load('assets/pes.riv');
    final file = RiveFile.import(data);
    setState(() {
      _riveArtboard = file.mainArtboard;
      if (_riveArtboard != null) {
        var controller = StateMachineController.fromArtboard(
            _riveArtboard!, 'State Machine 1');
        if (controller != null) {
          _riveArtboard!.addController(controller);
          // print all the state machine and type
          controller.stateMachine.inputs.forEach((element) {
            print(element.name + " " + element.runtimeType.toString());
          });

          _startTrigger = controller.findSMI('Processing');
          _shakeTrigger = controller.findSMI('Shake');

          // _startTrigger = controller.findSMI('start');
        }
      }
    });
  }
 void startTimer() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer timer) {
      if (_timerDuration == 0) {
        timer.cancel();
        setState(() {
          _shakeTrigger!.fire();
          _startTrigger!.value = false;
        });
      } else {
        setState(() {
          _timerDuration--;
        });
      }
    });
  }
  var _timerDuration = 0;

  @override
  void initState() {
    _initializeRive();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: "title",
            child: Icon(
              Icons.alarm,
              size: 30,
              color: Colors.brown,
            ),
          ),
          Text('Timer Screen'),
        ],
      )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: SizedBox(
                height: 200,
                width: 200,
                child: _riveArtboard != null
                    ? _riveArtboard == null
                        ? const SizedBox()
                        : Rive(
                            artboard: _riveArtboard!,
                            fit: BoxFit.cover,
                          )
                    : const SizedBox(),
              ),
            ),
            Text('Timer Duration: $_timerDuration'),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Add Timer'),
                      content: TextField(
                        decoration: InputDecoration(
                            hintText: 'Enter timer duration in seconds'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _timerDuration = int.parse(value);
                          });
                          // Handle timer input
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Add timer logic
                            Navigator.of(context).pop();
                          },
                          child: Text('Add'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Add Timer'),
            ),
            TextButton(
              onPressed: () {
                startTimer();
                print('Start: ${_startTrigger}');
                if (_startTrigger != null) {
                  _startTrigger!.value = true;
                }
              },
              child: Text('Start'),
            ),
            TextButton(
              onPressed: () {
                print('Stop: ${_startTrigger}');
                if (_startTrigger != null) {
                  _shakeTrigger!.fire();
                  _startTrigger!.value = false;
                }
              },
              child: Text('Stop'),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     print('Idle: ${_idleTrigger}');
            //     if (_idleTrigger != null) {
            //       _startTrigger!.value = false;
            //       _idleTrigger!.fire();
            //     }
            //   },
            //   child: Text('Idle'),
            // ),
          ],
        ),
      ),
    );
  }
}
