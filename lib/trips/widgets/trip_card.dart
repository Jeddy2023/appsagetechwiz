import 'package:flutter/material.dart';

import '../screens/trip_detail.dart';

class TripCard extends StatelessWidget {
  final String tripName;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final double budget;

  const TripCard({
    super.key,
    required this.tripName,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return TripDetailPage(
            id: '1',
            tripName: tripName,
            destination: destination,
            startDate: startDate,
            endDate: endDate,
            budget: budget,
          );
        }));
      },
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          border: Border(
            left: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 5.0,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tripName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildInfoColumn(
                    context,
                    'Start',
                    _formatDate(startDate),
                    Icons.calendar_today,
                  ),
                ),
                Expanded(
                  child: _buildInfoColumn(
                    context,
                    'End',
                    _formatDate(endDate),
                    Icons.event,
                  ),
                ),
                Expanded(
                  child: _buildInfoColumn(
                    context,
                    'Budget',
                    '\$${budget.toStringAsFixed(2)}',
                    Icons.account_balance_wallet,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(
      BuildContext context, String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
