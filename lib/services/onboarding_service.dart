import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static const String _onboardingKey = 'has_seen_onboarding';

  static Future<bool> hasSeenOnboarding() async {
    // Temporarily return false to always show onboarding for testing
    return false; // Change this back to: prefs.getBool(_onboardingKey) ?? false;
    // final prefs = await SharedPreferences.getInstance();
    // return prefs.getBool(_onboardingKey) ?? false;
  }

  static Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  static Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingKey);
  }
}
