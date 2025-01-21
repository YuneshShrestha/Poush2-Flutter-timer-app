import 'dart:async';

import 'package:before_class_timer_app/screen/home_screeen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    Timer(Duration(seconds: 5), () {
      // Get.offAll(
      //   HomeScreeen(),
      //   transition: Transition.downToUp,
      //   duration: Duration(
      //     seconds: 2,
      //   ),
      // );
      Navigator.pushReplacement(context, _createRoute());
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

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, _, __) {
        return HomeScreeen();
      },
      transitionDuration: Duration(
        seconds: 4,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // width or height [Offset]
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0.0, 1.0),
            end: Offset(0.0, 0.0),
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.ease,
          )),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Implicit
            TweenAnimationBuilder(
              //  Opacity ni use garnu
              tween: ColorTween(
                begin: Colors.amber,
                end: Colors.brown,
              ),
              duration: Duration(seconds: 5),
              builder: (context, value, child) {
                return Hero(
                  tag: 'icon',
                  child: Icon(
                    Icons.alarm,
                    size: 60,
                    color: value,
                  ),
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
