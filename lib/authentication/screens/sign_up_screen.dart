import 'package:flutter/material.dart';
import 'package:appsagetechwiz/authentication/widgets/or_separator.dart';
import 'package:appsagetechwiz/authentication/widgets/sign_up_form.dart';
import 'package:appsagetechwiz/authentication/widgets/social_signup_card.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

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
                Text("Register now",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                      children: [
                        TextSpan(
                            text: "Already have an account? ",
                            style: Theme.of(context).textTheme.bodyLarge),
                        TextSpan(
                          text: "Login",
                          style: TextStyle(
                            color: Colors.blue[800]!,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const SignUpForm(),
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
