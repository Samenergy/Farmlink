import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'create_account_screen.dart';
import 'login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmLink',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/createAccount': (context) => CreateAccountScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}