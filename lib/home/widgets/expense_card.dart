import 'package:flutter/material.dart';

class ExpenseCard extends StatelessWidget {
  final double amount;
  final String title;
  final String category;

  const ExpenseCard(
      {super.key,
      required this.amount,
      required this.category,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.money_sharp),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(category, style: Theme.of(context).textTheme.bodyLarge)
                ],
              ),
            ],
          ),
          Text(
            "$amount",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
