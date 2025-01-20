import 'dart:async';

import 'package:before_class_timer_app/screen/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _textController;
  late Animation<double> _textAnimation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(context, _createRoute());
    });
    _textController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _textAnimation = TweenSequence([
      TweenSequenceItem(
        tween:
            Tween(begin: 0.0, end: 0.5).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.5, end: 1.0)
            .chain(CurveTween(curve: Curves.bounceOut)),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeInOut,
      ),
    );
    _textController.forward();
  }


  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, _, __) => HomeScreen(),
      transitionsBuilder: (context, animation, _, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve,) );
        var offsetAnimation = animation.drive(tween);
        var scaleAnimation = animation.drive(Tween(begin: 0.0, end: 1.0));
        return ScaleTransition(
          scale: scaleAnimation,
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
          children: <Widget>[
            TweenAnimationBuilder(
                tween: IntTween(
                  begin: 0,
                  end: 100,
                ),
                duration: Duration(seconds: 2),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value / 100,
                    child: TweenAnimationBuilder(
                      tween: SizeTween(begin: Size(0, 0), end: Size(100, 100)),
                      duration: Duration(
                        seconds: 2,
                      ),
                      builder: (context, size, child) {
                        return FlutterLogo(size: size?.width);
                      },
                    ),
                  );
                }),
            AnimatedBuilder(
              animation: _textAnimation,
              builder: (context, _) {
                return Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'Welcome to Flutter Timer App',
                    style: TextStyle(
                      fontSize: _textAnimation.value * 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
