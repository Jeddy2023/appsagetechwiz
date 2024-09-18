import 'package:appsagetechwiz/custom_widgets/custom_button.dart';
import 'package:appsagetechwiz/custom_widgets/custom_text_field.dart';
import 'package:appsagetechwiz/utilis/toaster_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final authService = ref.read(authServiceProvider);
    final errorMessage = await authService.signUp(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (errorMessage == null) {
      // Navigate to the Login screen
      Navigator.pushNamed(context, '/login');
    } else {
      // Show an error message using ScaffoldMessenger
      ToasterUtils.showCustomSnackBar(context, errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            placeholder: "Full name",
            label: "Full name",
            controller: nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              if (value.split(" ").length < 2) {
                return 'Please enter at least two words for your full name';
              }
              return null;
            },
            prefixIcon: const Icon(
              Icons.person_outline,
              color: Colors.grey,
              size: 21,
            ),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            placeholder: "Email",
            label: "Email",
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            prefixIcon: const Icon(
              Icons.alternate_email,
              color: Colors.grey,
              size: 21,
            ),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            placeholder: "Password",
            label: "Password",
            isPassword: true,
            controller: passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: Colors.grey,
              size: 21,
            ),
          ),
          const SizedBox(height: 20),
          CustomButton(
            onPressed: () {
              _signUp(context);
            },
            buttonText: "Register now",
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
