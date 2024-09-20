import 'package:flutter/material.dart';

class NoTripCard extends StatelessWidget {
  const NoTripCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).colorScheme.primary,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "No Current Trip",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              "It's time to plan your next adventure and create lasting memories.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 24),
            Text(
              "Start exploring new destinations and unlock endless possibilities.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    height: 1.4,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
