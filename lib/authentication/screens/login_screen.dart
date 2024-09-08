import 'package:appsagetechwiz/authentication/widgets/or_separator.dart';
import 'package:appsagetechwiz/authentication/widgets/social_signup_card.dart';
import 'package:flutter/material.dart';
import 'package:appsagetechwiz/authentication/widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome Back",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to Sign Up page
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                      children: [
                        TextSpan(
                            text: "Don't have an account? ",
                            style: Theme.of(context).textTheme.bodyLarge),
                        TextSpan(
                          text: "Sign Up",
                          style: TextStyle(
                            color: Colors.blue[800]!,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const LoginForm(),
                const SizedBox(height: 25),
                const OrSeparator(),
                const SizedBox(
                  height: 25,
                ),
                const SocialSignupCard(
                    iconFilePath: "assets/images/auth/google.svg",
                    textContent: "Continue with Google"),
                const SizedBox(
                  height: 18,
                ),
                const SocialSignupCard(
                    iconFilePath: "assets/images/auth/facebook.svg",
                    textContent: "Continue with Facebook")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
