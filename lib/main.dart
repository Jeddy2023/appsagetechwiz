import 'package:appsagetechwiz/authentication/screens/account_verification.dart';
import 'package:appsagetechwiz/authentication/screens/login_screen.dart';
import 'package:appsagetechwiz/authentication/screens/sign_up_screen.dart';
import 'package:appsagetechwiz/home/screens/home_screen.dart';
import 'package:appsagetechwiz/main_screen.dart';
import 'package:appsagetechwiz/onboarding/screens/main.dart';
import 'package:appsagetechwiz/profile/widgets/edit_profile.dart';
import 'package:appsagetechwiz/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ProviderScope(
      child: MaterialApp(
          initialRoute: '/main',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/edit-profile': (context) => const EditProfile(),
        '/main': (context) => const MainScreen(),
        '/account-verification': (context) => const AccountVerification(),
      })));
}
