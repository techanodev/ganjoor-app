import 'package:flutter/material.dart';
import 'dart:math';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    AnimationController _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    Animation _animation =
        Tween<double>(begin: 0, end: 2 * pi).animate(_controller)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _controller.reset();
              _controller.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _controller.forward();
            }
          });

    _controller.forward();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              child: Image.asset(
                'assets/icon.png',
                width: 150,
              ),
              builder: (context, child) {
                return Transform.rotate(
                  angle: _animation.value,
                  child: child,
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('در حال دریافت اطلاعات'),
            ),
            const Text(
              'می پسندد یار این آشفتگی\n' + 'کوشش بیهوده به از خفتگی',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
