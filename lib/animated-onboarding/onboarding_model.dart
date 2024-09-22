class OnboardingModel {
  final String lottieURL;
  final String title;
  final String subtitle;

  OnboardingModel({
    required this.lottieURL,
    required this.title,
    required this.subtitle,
  });
}

// List of items to be displayed in the onboarding screen
List<OnboardingModel> onboardingItems = [
  OnboardingModel(
    lottieURL: 'assets/Lottie/Yokoso.json',  // Local file for welcome animation
    title: 'Welcome to Trip Budgeter',
    subtitle: 'Your one-stop app for budgeting trips, booking, and more!',
  ),
  OnboardingModel(
    lottieURL: 'assets/Lottie/book_trip.json',  // Local file for book trip animation
    title: 'Book Trips Easily',
    subtitle: 'Choose destinations, book, and manage your trips seamlessly.',
  ),
  OnboardingModel(
    lottieURL: 'assets/Lottie/Budget.json',  // Local file for budgeting animation
    title: 'Budget With Confidence',
    subtitle: 'Plan your trips effortlessly and stay in control of your budget.',
  ),
];
