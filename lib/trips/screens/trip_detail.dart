import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TripDetailPage extends StatelessWidget {
  final String id;
  final String tripName;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final double budget;
  final List<Expense> expenses;

  const TripDetailPage({
    super.key,
    required this.id,
    required this.tripName,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.budget,
    this.expenses = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTripOverview(context),
                  const SizedBox(height: 24),
                  _buildTripDetails(context),
                  const SizedBox(height: 24),
                  _buildExpensesList(context),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add expense
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      foregroundColor: Theme.of(context).colorScheme.secondary,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(tripName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                )),
        background: Image.network(
          'https://plus.unsplash.com/premium_photo-1664304598312-6de674eb1b79?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTripOverview(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          border: Border(
            left: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 5.0,
            ),
          )),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              destination,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '${DateFormat('MMM d').format(startDate)} - ${DateFormat('MMM d, yyyy').format(endDate)}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trip Details',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        _buildDetailCard(context, [
          _buildDetailRow(context, 'Duration', _calculateDuration()),
          _buildDetailRow(context, 'Budget', '\$${budget.toStringAsFixed(2)}'),
          _buildDetailRow(context, 'Spent',
              '\$${_calculateTotalExpenses().toStringAsFixed(2)}'),
          _buildDetailRow(context, 'Remaining',
              '\$${(budget - _calculateTotalExpenses()).toStringAsFixed(2)}'),
        ]),
      ],
    );
  }

  Widget _buildDetailCard(BuildContext context, List<Widget> children) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildExpensesList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Expenses',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: expenses.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return ListTile(
                title: Text(expense.description),
                subtitle: Text(DateFormat('MMM d, yyyy').format(expense.date)),
                trailing: Text(
                  '\$${expense.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _calculateDuration() {
    final duration = endDate.difference(startDate);
    return '${duration.inDays} days';
  }

  double _calculateTotalExpenses() {
    return expenses.fold(0, (sum, expense) => sum + expense.amount);
  }
}

class Expense {
  final String description;
  final double amount;
  final DateTime date;

  Expense(
      {required this.description, required this.amount, required this.date});
}
