import 'package:flutter/material.dart';

class OrSeparator extends StatelessWidget {
  final String text;
  final double lineThickness;

  const OrSeparator({
    super.key,
    this.text = "OR",
    this.lineThickness = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: lineThickness,
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: lineThickness,
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
      ],
    );
  }
}
