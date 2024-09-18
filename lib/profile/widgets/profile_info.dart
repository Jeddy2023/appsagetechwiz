import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  final String profilePicture;
  final String fullName;
  final String email;

  const ProfileInfo(
      {super.key,
      required this.profilePicture,
      required this.fullName,
      required this.email});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: Image.network(profilePicture).image,
              backgroundColor: const Color.fromRGBO(135, 206, 235, 0.6),
              radius: 50,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              fullName,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              email,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
