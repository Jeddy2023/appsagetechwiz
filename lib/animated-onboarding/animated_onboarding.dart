import 'package:flutter/material.dart';
import 'package:appsagetechwiz/animated-onboarding/onboarding_model.dart';
import 'package:appsagetechwiz/authentication/screens/sign_up_screen.dart';
import 'package:lottie/lottie.dart';

class AnimatedOnboardingScreen extends StatefulWidget {
  const AnimatedOnboardingScreen({super.key});

  @override
  State<AnimatedOnboardingScreen> createState() =>
      _AnimatedOnboardingScreenState();
}

class _AnimatedOnboardingScreenState extends State<AnimatedOnboardingScreen> {
  final PageController pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomPaint(
            painter: ArcPaint(),
            child: SizedBox(
              height: size.height / 1.35,
              width: size.width,
            ),
          ),
          // For Lottie animation file
          Positioned(
            top: 220,
            right: 0,
            left: 0,
            child: Lottie.network(
              onboardintItems[currentIndex].lottieURL,
              width: 500,
              alignment: Alignment.topCenter,
            ),
          ),
          // For scrolling
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 270,
              child: Column(
                children: [
                  Flexible(
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: onboardintItems.length,
                      itemBuilder: (context, index) {
                        final items = onboardintItems[index];
                        return Column(
                          children: [
                            Text(
                              items.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 50),
                            Text(
                              items.subtitle,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        );
                      },
                      onPageChanged: (value) {
                        setState(() {
                          currentIndex = value;
                        });
                      },
                    ),
                  ),
                  // Dot indicator
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int index = 0; index < onboardintItems.length; index++)
                        dotIndicator(isSelected: index == currentIndex),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
          // Previous and Next arrow buttons aligned on the same row
          Positioned(
            bottom: 80,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentIndex > 0) // Show only from the second slide
                  FloatingActionButton(
                    onPressed: () {
                      pageController.previousPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease);
                    },
                    elevation: 0,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.arrow_back_ios, color: Colors.black),
                  )
                else
                  Container(), // Placeholder for alignment when back button is hidden
                FloatingActionButton(
                  onPressed: () {
                    if (currentIndex < onboardintItems.length - 1) {
                      pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.linear);
                    } else {
                      // Navigate to the next screen after the last onboarding
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    }
                  },
                  elevation: 0,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.arrow_forward_ios, color: Colors.black),
                ),
              ],
            ),
          ),
          // Skip button
          Positioned(
            top: 30,
            right: 20,
            child: TextButton(
              onPressed: () {
                // Navigate to the next screen or home screen
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const SignUpScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Skip',
                  style: TextStyle(color: Colors.blue, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dotIndicator({required bool isSelected}) {
    return Padding(
      padding: const EdgeInsets.only(right: 7),
      child: AnimatedContainer(
        duration: const Duration(microseconds: 500),
        height: isSelected ? 8 : 6,
        width: isSelected ? 8 : 6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.black : Colors.black26,
        ),
      ),
    );
  }
}

class ArcPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path orangeArc = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height - 175)
      ..quadraticBezierTo(
          size.width / 2, size.height, size.width, size.height - 175)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(orangeArc, Paint()..color = Colors.orange);

    Path whiteArc = Path()
      ..moveTo(0.0, 0.0)
      ..lineTo(0.0, size.height - 180)
      ..quadraticBezierTo(
          size.width / 2, size.height - 60, size.width, size.height - 180)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(
      whiteArc,
      Paint()..color = const Color.fromARGB(255, 144, 202, 249),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
