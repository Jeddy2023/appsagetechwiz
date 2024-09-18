import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;

  const CustomListTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle = '',
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).inputDecorationTheme.fillColor),
          child: ListTile(
            leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
            title: Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, route);
            },
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
