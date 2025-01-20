import 'dart:async';

import 'package:before_class_timer_app/screen/home_screeen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> textAnimation; // fontsize
  late AnimationController textAnimationController;
  @override
  void initState() {
    Timer(Duration(seconds:7), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomeScreeen();
      }));
    });
    textAnimationController = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 3,
      ),
    );
    // textAnimation = Tween(begin: 0.0, end: 1.0).animate(
    //     CurvedAnimation(parent: textAnimationController, curve: Curves.easeIn));
    textAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 0.5)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50),
      TweenSequenceItem(
          tween: Tween(
            begin: 0.5,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.bounceOut)),
          weight: 50),
    ]).animate(
      CurvedAnimation(parent: textAnimationController, curve: Curves.easeIn),
    );
    textAnimationController.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder(
              //  Opacity ni use garnu
              tween: ColorTween(
                begin: Colors.amber,
                end: Colors.brown,
              ),
              duration: Duration(seconds: 5),
              builder: (context, value, child) {
                return Icon(
                  Icons.alarm,
                  size: 60,
                  color: value,
                );
              },
            ),
            // AnimatedOpacity(
            //   duration: Duration(
            //     seconds: 4,
            //   ),
            //   curve: Curves.easeInOut,
            //   opacity: 1, //0{l}-1(h)
            //   child: FlutterLogo(
            //     size: 100,
            //   ),
            // ),
            // TweenAnimationBuilder(
            //     tween: IntTween(
            //       begin: 0,
            //       end: 100,
            //     ),
            //     duration: Duration(
            //       seconds: 4,
            //     ),
            //     builder: (context, value, _) {
            //       return Opacity(
            //         opacity: value/100, // value: 0-100 -> 0-1
            //         child: Text(
            //           "Timer App",
            //           style: TextStyle(
            //             fontSize: 40,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       );
            //     })
            AnimatedBuilder(
              animation: textAnimation,
              builder: (context, child) {
                return Text(
                  "Timer App",
                  style: TextStyle(
                    fontSize: 40 * textAnimation.value,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
            // TweenAnimationBuilder(
            //     tween: Tween(
            //       begin: 0.0,
            //       end: 1.0,
            //     ),
            //     duration: Duration(
            //       seconds: 4,
            //     ),
            //     builder: (context, size, _) {
            //       return Text(
            //         "Timer App",
            //         style: TextStyle(
            //           fontSize: 40 * textAnimation.value,
            //           fontWeight: FontWeight.w600,
            //         ),
            //       );
            //     })
          ],
        ),
      ),
    );
  }
}
