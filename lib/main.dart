import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'welcome_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

void main() {
  runApp(MyApp());
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
      home: SplashScreen(),
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
      },
    );
  }
}
