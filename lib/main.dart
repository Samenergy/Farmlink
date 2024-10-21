import 'package:flutter/material.dart';
import 'onboarding_screen.dart'; // Import the new file

void main() {
  runApp(FarmLinkApp());
}

class FarmLinkApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(), // Set OnboardingScreen as the home screen
    );
  }
}
