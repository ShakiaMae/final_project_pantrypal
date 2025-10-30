import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:final_project_pantrypal/domain/custom_text_style.dart';
import 'package:final_project_pantrypal/screen/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/icons/cook-book.png"),
            SizedBox(
              height: 60,
              child: DefaultTextStyle(
                style: myTextStyle48(
                  textFamily: 'secondary',
                  textWeight: FontWeight.bold,
                ),
                child: AnimatedTextKit(
                  pause: const Duration(milliseconds: 50),
                  animatedTexts: [
                    ScaleAnimatedText("Kitchen"),
                    ScaleAnimatedText("Craft"),
                  ],
                )),
            ),
          ],
        ),
      ),
    );
  }
}
