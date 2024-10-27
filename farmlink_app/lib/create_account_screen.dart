import 'package:flutter/material.dart';

class CreateAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset('assets/farmlink_logo.png', height: 50),
              SizedBox(height: 40),
              // Form fields
              TextField(
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle create account logic
                },
                child: Text('Create account'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                ),
              ),
              SizedBox(height: 20),
              Text('Or Sign up with'),
              SizedBox(height: 20),
              // Social Media Icons Row (Google, Facebook, Twitter/X)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google icon
                  IconButton(
                    icon: Image.asset('assets/google_icon.png'),
                    iconSize: 40,
                    onPressed: () {
                      // Google sign up logic
                    },
                  ),
                  SizedBox(width: 20),
                  // Facebook icon
                  IconButton(
                    icon: Image.asset('assets/facebook_icon.png'),
                    iconSize: 40,
                    onPressed: () {
                      // Facebook sign up logic
                    },
                  ),
                  SizedBox(width: 20),
                  // Twitter (X) icon
                  IconButton(
                    icon: Image.asset('assets/x_icon.png'),
                    iconSize: 40,
                    onPressed: () {
                      // Twitter (X) sign up logic
                    },
                  ),
                  SizedBox(width: 20),
                  // Alternative sign up (clear icon)
                  IconButton(
                    icon: Icon(Icons.clear, size: 40),
                    onPressed: () {
                      // Alternative sign up logic
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}