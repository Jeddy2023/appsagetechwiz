import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
// import 'package:appsagetechwiz/onboarding/screens/intro_screen_one.dart';
import 'package:appsagetechwiz/animated-onboarding/animated_onboarding.dart';


class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  get splash => null;

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(splash:
        Column(
          children: [
            Center(
              child: LottieBuilder.asset("assets/Lottie/Animation - 1726754715755.json"),
            )
          ],
        ), nextScreen: const AnimatedOnboardingScreen(),
        splashIconSize: 400,
        backgroundColor: Colors.blueAccent,);
  }
}
