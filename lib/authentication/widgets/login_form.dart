import 'package:appsagetechwiz/utilis/toaster_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appsagetechwiz/custom_widgets/custom_button.dart';
import 'package:appsagetechwiz/custom_widgets/custom_text_field.dart';
import '../../providers/auth_provider.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final authService = ref.read(authServiceProvider);
    final errorMessage = await authService.signIn(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (errorMessage == null) {
      // Successful login, navigate to the home screen
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      // Show error message using a SnackBar
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
              _login(context);
            },
            buttonText: "Login",
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
