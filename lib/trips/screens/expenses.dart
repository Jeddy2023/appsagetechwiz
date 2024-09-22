import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:appsagetechwiz/providers/auth_provider.dart';
import 'package:appsagetechwiz/trips/screens/log_expense.dart';

class ExpensesPage extends ConsumerStatefulWidget {
  final String tripId;
  final String tripName;

  const ExpensesPage({
    super.key,
    required this.tripId,
    required this.tripName,
  });

  @override
  ConsumerState<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends ConsumerState<ExpensesPage> {
  late Future<List<Map<String, dynamic>>> _expensesFuture;

  @override
  void initState() {
    super.initState();
    _expensesFuture = _fetchExpenses();
  }

  Future<List<Map<String, dynamic>>> _fetchExpenses() async {
    final authService = ref.read(authServiceProvider);
    return await authService.fetchExpenses(widget.tripId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.tripName} Expenses',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh,
                color: Theme.of(context).colorScheme.onPrimary),
            onPressed: () {
              setState(() {
                _expensesFuture = _fetchExpenses();
              });
            },
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _expensesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              );
            } else if (snapshot.hasData) {
              final expenses = snapshot.data!;
              return _buildExpensesList(context, expenses);
            } else {
              return Center(
                child: Text(
                  'No expenses found',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  LogExpensePage(tripId: widget.tripId),
            ),
          );
          setState(() {
            _expensesFuture = _fetchExpenses();
          });
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        child:
            Icon(Icons.add, color: Theme.of(context).colorScheme.onSecondary),
      ),
    );
  }

  Widget _buildExpensesList(
      BuildContext context, List<Map<String, dynamic>> expenses) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            elevation: 3,
            color: Theme.of(context).colorScheme.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                expense['Title'] ?? 'Untitled',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('MMM d, yyyy')
                        .format(expense['Expense_Date'].toDate()),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                  ),
                ],
              ),
              trailing: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '\$${(expense['Amount'] as num).toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
