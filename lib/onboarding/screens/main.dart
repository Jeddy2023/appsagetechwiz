import 'package:appsagetechwiz/custom_widgets/custom_button.dart';
import 'package:appsagetechwiz/onboarding/screens/intro_screen_one.dart';
import 'package:appsagetechwiz/onboarding/screens/intro_screen_three.dart';
import 'package:appsagetechwiz/onboarding/screens/intro_screen_two.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                onLastPage = index == 2;
              });
            },
            children: const [
              IntroScreenOne(),
              IntroScreenTwo(),
              IntroScreenThree(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: WormEffect(
                      activeDotColor: Theme.of(context).colorScheme.primary,
                      dotHeight: 8,
                      dotWidth: 8),
                ),
                const SizedBox(
                  height: 30,
                ),
                !onLastPage
                    ? CustomButton(
                        onPressed: () {
                          _pageController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInCubic);
                        },
                        buttonText: 'Continue')
                    : CustomButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        buttonText: 'Get Started',
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
