import 'package:flutter/material.dart';
import '../screens/trip_detail.dart';
import 'package:intl/intl.dart';

class TripCard extends StatelessWidget {
  final String tripId;
  final String tripName;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final double budget;

  const TripCard({
    super.key,
    required this.tripId,
    required this.tripName,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    bool hasEnded = endDate.isBefore(DateTime.now());
    bool isOngoing =
        startDate.isBefore(DateTime.now()) && endDate.isAfter(DateTime.now());

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TripDetailPage(
                id: tripId,
                tripName: tripName,
                destination: destination,
                startDate: startDate,
                endDate: endDate,
                budget: budget,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      tripName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusIndicator(hasEnded, isOngoing),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                destination,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoItem(context, 'Start', _formatDate(startDate)),
                  _buildInfoItem(context, 'End', _formatDate(endDate)),
                  _buildInfoItem(context, 'Budget', _formatBudget(budget)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(bool hasEnded, bool isOngoing) {
    Color indicatorColor =
        hasEnded ? Colors.grey : (isOngoing ? Colors.green : Colors.blue);
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: indicatorColor,
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  String _formatBudget(double budget) {
    return NumberFormat.compactCurrency(symbol: '\$').format(budget);
  }
}
