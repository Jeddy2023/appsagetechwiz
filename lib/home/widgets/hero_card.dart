import 'package:flutter/material.dart';

class HeroCard extends StatelessWidget {
  final String tripName;
  final double budget;
  final double spent;

  const HeroCard({
    super.key,
    required this.tripName,
    required this.budget,
    required this.spent,
  });

  @override
  Widget build(BuildContext context) {
    final percentageSpent = (spent / budget).clamp(0.0, 1.0);
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Current Trip",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                  const Icon(Icons.flight_takeoff,
                      color: Colors.white, size: 28),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                tripName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 24),
              _buildBudgetInfo(
                  context, "Budget", budget, Icons.account_balance_wallet),
              const SizedBox(height: 12),
              _buildBudgetInfo(context, "Spent", spent, Icons.shopping_cart),
              const SizedBox(height: 24),
              _buildProgressBar(context, percentageSpent),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetInfo(
      BuildContext context, String label, double amount, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 8),
        Text(
          "$label:",
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.white70),
        ),
        const SizedBox(width: 8),
        Text(
          "\$${amount.toStringAsFixed(2)}",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context, double percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Budget Used",
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: percentage,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: percentage > 0.8 ? Colors.red : Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "${(percentage * 100).toStringAsFixed(1)}%",
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
