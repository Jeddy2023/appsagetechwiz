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
List<OnboardingModel> onboardintItems = [
  OnboardingModel(
    lottieURL: 'https://assets5.lottiefiles.com/packages/lf20_x62chJ.json',
    title: 'Welcome to the App',
    subtitle: 'This app helps you achieve great things!',
  ),
  OnboardingModel(
    lottieURL: 'https://assets5.lottiefiles.com/packages/lf20_x62chJ.json',
    title: 'Track Your Progress',
    subtitle: 'Monitor your goals and reach new heights.',
  ),
  OnboardingModel(
    lottieURL: 'https://assets5.lottiefiles.com/packages/lf20_x62chJ.json',
    title: 'Stay Connected',
    subtitle: 'Join a community of like-minded people.',
  ),
];
