import 'package:flutter/material.dart';

class IntroScreenThree extends StatelessWidget {
  const IntroScreenThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  double diameter = constraints.maxWidth * 0.8;
                  return SizedBox(
                    width: diameter,
                    height: diameter,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            "assets/images/onboarding/delivery-service.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 35),
              Text(
                "Reliable Delivery Service",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Enjoy fast, reliable gas delivery with Gas Refill Hub, so you can focus on what matters most.",
                style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSurface),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
