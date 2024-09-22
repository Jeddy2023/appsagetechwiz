import 'package:appsagetechwiz/home/widgets/expense_card.dart';
import 'package:appsagetechwiz/home/widgets/hero_card.dart';
import 'package:appsagetechwiz/home/widgets/no_trip_card.dart';
import 'package:appsagetechwiz/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<List<dynamic>> _combinedFuture;

  @override
  void initState() {
    super.initState();
    final authService = ref.read(authServiceProvider);

    // Fetch user details, current trip, and last five expenses
    _combinedFuture = Future.wait([
      authService.getCurrentUser(),
      authService.getCurrentTrip(),
      authService.getLastFiveExpensesForCurrentTrip(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _combinedFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final userData = snapshot.data![0] as Map<String, dynamic>?;
          final tripData = snapshot.data![1] as Map<String, dynamic>?;
          final expensesData = snapshot.data![2] as List<Map<String, dynamic>>;

          if (userData == null) {
            return const Center(child: Text('No user data available'));
          }

          final firstName = userData['First_Name'] ?? 'User';
          final profilePicture = userData['Profile_Picture'] ??
              'https://res.cloudinary.com/dn7xnr4ll/image/upload/v1722866767/notionistsNeutral-1722866616198_iu61hw.png';

          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  "Hi, $firstName",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                forceMaterialTransparency: true,
                leadingWidth: 70,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(profilePicture),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      if (tripData != null)
                        HeroCard(
                          tripName: tripData['Trip_Name'],
                          budget: tripData['Budget']?.toDouble() ?? 0.0,
                          spent: expensesData.fold(
                              0.0,
                              (sum, expense) =>
                                  sum + (expense['Amount'] ?? 0.0)),
                        )
                      else
                        const NoTripCard(),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text('Recent Expenses',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: expensesData.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.receipt_long,
                                      size: 64,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No recent expenses',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                itemBuilder: (context, index) {
                                  final expense = expensesData[index];
                                  return ExpenseCard(
                                    amount:
                                        expense['Amount']?.toDouble() ?? 0.0,
                                    category: expense['Category'] ?? '',
                                    title: expense['Title'] ?? '',
                                  );
                                },
                                separatorBuilder: (context, index) => Divider(
                                  height: 1,
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                                itemCount: expensesData.length,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
