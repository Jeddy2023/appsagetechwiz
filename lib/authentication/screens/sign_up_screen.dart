import 'package:appsagetechwiz/utilis/toaster_utils.dart';
import 'package:flutter/material.dart';
import 'package:appsagetechwiz/authentication/widgets/or_separator.dart';
import 'package:appsagetechwiz/authentication/widgets/sign_up_form.dart';
import 'package:appsagetechwiz/authentication/widgets/social_signup_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  // Method to handle Google sign-in
  Future<void> googleSignInHandler() async {
    final authService = ref.read(authServiceProvider);
    String? result = await authService.signInWithGoogle();
    if (result == null) {
      ToasterUtils.showCustomSnackBar(context, 'Sign-in successful',
          isError: false);
      Navigator.pushNamed(context, '/main');
    } else {
      ToasterUtils.showCustomSnackBar(context, result);
    }
  }

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
                SocialSignupCard(
                  iconFilePath: "assets/images/auth/google.svg",
                  textContent: "Continue with Google",
                  onTap: googleSignInHandler,
                ),
                const SizedBox(
                  height: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
