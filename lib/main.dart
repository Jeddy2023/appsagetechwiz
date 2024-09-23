import 'package:appsagetechwiz/authentication/screens/account_verification.dart';
import 'package:appsagetechwiz/authentication/screens/login_screen.dart';
import 'package:appsagetechwiz/authentication/screens/sign_up_screen.dart';
import 'package:appsagetechwiz/home/screens/home_screen.dart';
import 'package:appsagetechwiz/main_screen.dart';
import 'package:appsagetechwiz/onboarding/screens/main.dart';
import 'package:appsagetechwiz/profile/widgets/app_preferences.dart';
import 'package:appsagetechwiz/profile/widgets/edit_profile.dart';
import 'package:appsagetechwiz/reports/widgets/generatereport_screen.dart';
import 'package:appsagetechwiz/theme/theme_constants.dart';
import 'package:appsagetechwiz/trips/widgets/create_trip_form.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appsagetechwiz/splashscreen/splash_screen.dart';
import 'package:appsagetechwiz/animated-onboarding/animated_onboarding.dart';
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
        '/splashscreen': (context) => const Splashscreen(),
        '/onboardings': (context) => const AnimatedOnboardingScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/edit-profile': (context) => const EditProfile(),
        '/default-settings': (context) => const AppPreferencesScreen(),
        '/main': (context) => const MainScreen(),
        '/add-trip': (context) => const CreateTripForm(),
        '/account-verification': (context) => const AccountVerification(),
        '/generate-report': (context) => const GenerateReportScreen(),
      })));
}
