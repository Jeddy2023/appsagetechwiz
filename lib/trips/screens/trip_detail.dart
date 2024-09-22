import 'package:appsagetechwiz/trips/screens/expenses.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appsagetechwiz/providers/auth_provider.dart';

class TripDetailPage extends ConsumerStatefulWidget {
  final String id;
  final String tripName;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final double budget;

  const TripDetailPage({
    super.key,
    required this.id,
    required this.tripName,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.budget,
  });

  @override
  ConsumerState<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends ConsumerState<TripDetailPage> {
  late Future<List<Map<String, dynamic>>> _expensesFuture;

  @override
  void initState() {
    super.initState();
    _expensesFuture = _fetchExpenses();
  }

  Future<List<Map<String, dynamic>>> _fetchExpenses() async {
    final authService = ref.read(authServiceProvider);
    return await authService.fetchExpenses(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _expensesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final expenses = snapshot.data!;
            return CustomScrollView(
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
                        _buildTripDetails(context, expenses),
                        const SizedBox(height: 24),
                        _buildExpensesSummary(context, expenses),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.secondary,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.tripName,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: -30,
              bottom: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.7),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.destination,
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripOverview(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary,
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.destination,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '${DateFormat('MMM d').format(widget.startDate)} - ${DateFormat('MMM d, yyyy').format(widget.endDate)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripDetails(
      BuildContext context, List<Map<String, dynamic>> expenses) {
    double totalSpent =
        expenses.fold(0, (sum, expense) => sum + (expense['Amount'] as num));
    double remaining = widget.budget - totalSpent;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trip Details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(context, 'Duration', _calculateDuration()),
            _buildDetailRow(
                context, 'Budget', '\$${widget.budget.toStringAsFixed(2)}'),
            _buildDetailRow(
                context, 'Spent', '\$${totalSpent.toStringAsFixed(2)}'),
            _buildDetailRow(
              context,
              'Remaining',
              '\$${remaining.toStringAsFixed(2)}',
              valueColor: remaining > 0 ? Colors.green : Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value,
      {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesSummary(
      BuildContext context, List<Map<String, dynamic>> expenses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Expenses',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExpensesPage(
                      tripId: widget.id,
                      tripName: widget.tripName,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: expenses.length > 3 ? 3 : expenses.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Theme.of(context).colorScheme.surface,
            ),
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return ListTile(
                title: Text(
                  expense['Title'] ?? 'Untitled',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  DateFormat('MMM d, yyyy')
                      .format(expense['Expense_Date'].toDate()),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: Text(
                    '\$${(expense['Amount'] as num).toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium),
              );
            },
          ),
        ),
      ],
    );
  }

  String _calculateDuration() {
    final duration = widget.endDate.difference(widget.startDate);
    return '${duration.inDays} days';
  }
}
