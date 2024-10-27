import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'splash_screen.dart';
import 'welcome_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

void main() {
  runApp(const ProviderScope(
      child: MyApp())); // Wrap with ProviderScope for Riverpod
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Farmlink',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      // Start from SplashScreen and navigate through routes
      home: const SplashScreen(),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
