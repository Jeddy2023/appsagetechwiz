import 'package:appsagetechwiz/home/widgets/expense_card.dart';
import 'package:appsagetechwiz/home/widgets/hero_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> expenses = [
    {"title": "Hotel Booking", "amount": 450.00, "category": "Accommodation"},
    {"title": "Flight Tickets", "amount": 800.00, "category": "Transportation"},
    {
      "title": "Dinner at Local Restaurant",
      "amount": 75.50,
      "category": "Food"
    },
    {
      "title": "Museum Entrance Fee",
      "amount": 20.00,
      "category": "Entertainment"
    },
    {"title": "Souvenir Shopping", "amount": 50.00, "category": "Shopping"},
    {
      "title": "Local Train Tickets",
      "amount": 30.00,
      "category": "Transportation"
    },
    {"title": "Groceries", "amount": 40.00, "category": "Food"},
    {"title": "City Tour Guide", "amount": 100.00, "category": "Entertainment"},
    {"title": "Travel Insurance", "amount": 80.00, "category": "Miscellaneous"},
    {"title": "Taxi Ride", "amount": 25.00, "category": "Transportation"}
  ];

  @override
  void initState() {
    super.initState();
    // TODO: IMPLEMENT LOGIC TO FETCH CURRENT TRIP AND RECENT EXPENSES
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Trip Budget Tracker'),
          elevation: 0,
          backgroundColor: Colors.transparent,
          forceMaterialTransparency: true,
          centerTitle: true,
          leading: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage('assets/images/general/avatar.png'),
                    fit: BoxFit.cover)),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {})
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
                const HeroCard(
                    tripName: "Europe Vacation", budget: 5000, spent: 3500),
                const SizedBox(height: 20),
                Text('Recent Expenses',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: ListView.separated(
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
                        itemCount: expenses.length)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
