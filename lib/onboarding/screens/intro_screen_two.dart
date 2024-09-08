import 'package:flutter/material.dart';

class IntroScreenTwo extends StatelessWidget {
  const IntroScreenTwo({super.key});

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
                            "assets/images/onboarding/online-payment.png",
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
                "Easy Mobile Payments",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface),
              ),
              const SizedBox(height: 10),
              Text(
                "Pay for gas refills securely from your mobile device with Gas Refill Hub for a convenient experience.",
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
