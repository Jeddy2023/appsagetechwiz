import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialSignupCard extends StatelessWidget {
  final String iconFilePath;
  final String textContent;

  const SocialSignupCard(
      {super.key, required this.iconFilePath, required this.textContent});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.surface),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            SvgPicture.asset(
              iconFilePath,
              height: 28,
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              textContent,
              style: Theme.of(context).textTheme.titleMedium,
            )
          ],
        ),
      ),
    );
  }
}
