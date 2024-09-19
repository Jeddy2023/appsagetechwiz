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
  late Future<Map<String, dynamic>?> _userDataFuture;
  final Map<String, dynamic> _currentTrip = {
    'tripName': 'Europe Vacation',
    'budget': 3000.00,
    'spent': 2000.00
  };

  List<Map<String, dynamic>> expenses = [
    {
      'title': 'Flight tickets',
      'amount': 500.00,
      'category': 'Travel',
    },
    {
      'title': 'Hotel stay',
      'amount': 300.00,
      'category': 'Travel',
    },
    {
      'title': 'Dinner',
      'amount': 50.00,
      'category': 'Food',
    },
    {
      'title': 'Groceries',
      'amount': 100.00,
      'category': 'Food',
    },
    {
      'title': 'Shopping',
      'amount': 200.00,
      'category': 'Shopping',
    },
  ];

  @override
  void initState() {
    super.initState();
    final authService = ref.read(authServiceProvider);
    _userDataFuture = authService.getCurrentUser();

    // TODO: Fetch current trips and expenses
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _userDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data != null) {
          final userData = snapshot.data!;
          final firstName = userData['First_Name'] ?? 'User';
          final profilePicture = userData['photoURL'] ??
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back!',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      _currentTrip.isEmpty
                          ? const NoTripCard()
                          : HeroCard(
                              tripName: _currentTrip['tripName'],
                              budget: _currentTrip['budget'],
                              spent: _currentTrip['spent']),
                      const SizedBox(height: 20),
                      Text('Recent Expenses',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Expanded(
                        child: expenses.isEmpty
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
                                  final expense = expenses[index];
                                  return ExpenseCard(
                                      amount: expense['amount'],
                                      category: expense['category'],
                                      title: expense['title']);
                                },
                                separatorBuilder: (context, index) => Divider(
                                  height: 1,
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                                itemCount: expenses.length,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Center(child: Text('No user data available'));
        }
      },
    );
  }
}
