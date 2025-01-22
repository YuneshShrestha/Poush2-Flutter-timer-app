import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class HomeScreeen extends StatefulWidget {
  const HomeScreeen({super.key});

  @override
  State<HomeScreeen> createState() => _HomeScreeenState();
}

class _HomeScreeenState extends State<HomeScreeen> {
  Artboard? riveArtBoard;
  SMIBool? processing;
  SMITrigger? shake;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadRiveFile();
  }

  loadRiveFile() async {
    await RiveFile.initialize();
    String rivePath = 'assets/pes.riv';
    var data = await rootBundle.load(rivePath);
    var file = RiveFile.import(data);
    setState(() {
      riveArtBoard = file.mainArtboard;
      // controller
      // StateMachineController
      if (riveArtBoard != null) {
        var controller = StateMachineController.fromArtboard(
          riveArtBoard!,
          'State Machine 1',
        );
        if (controller != null) {
          riveArtBoard!.addController(controller);
          controller.stateMachine.inputs.forEach((e) {
            print(e.name + " " + e.runtimeType.toString());
          });
          processing = controller.findSMI('Processing');
          shake = controller.findSMI('Shake');
        }
      }
    });
  }

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
      body: Center(
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
                child: riveArtBoard == null
                    ? SizedBox()
                    : Rive(
                        artboard: riveArtBoard!,
                      ),
              ),
            ),
            // Text
            Text('Current time: 30 second'),
            //  Add Timer Button
            ElevatedButton(
              onPressed: () {},
              child: Text("Add Timer"),
            ),
            //  Start Button
            TextButton(
              onPressed: () {
                if (processing != null) {
                  processing!.value = true;
                }
              },
              child: Text("Start"),
            ),

            //  Stop Button
            TextButton(
              onPressed: () {
                if (processing != null && shake != null) {
                  shake!.fire();
                  processing!.value = false;
                }
              },
              child: Text("Stop"),
            ),
          ],
        ),
      ),
    );
  }
}