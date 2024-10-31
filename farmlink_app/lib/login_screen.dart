import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
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
              // Email field
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              // Password field
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
                  // Handle login logic
                },
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Handle forgot password
                },
                child: Text('Forgot your password?'),
              ),
              SizedBox(height: 20),
              Text('Or Sign in with'),
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
                      // Google sign in logic
                    },
                  ),
                  SizedBox(width: 20),
                  // Facebook icon
                  IconButton(
                    icon: Image.asset('assets/facebook_icon.png'),
                    iconSize: 40,
                    onPressed: () {
                      // Facebook sign in logic
                    },
                  ),
                  SizedBox(width: 20),
                  // Twitter (X) icon
                  IconButton(
                    icon: Image.asset('assets/x_icon.png'),
                    iconSize: 40,
                    onPressed: () {
                      // Twitter (X) sign in logic
                    },
                  ),
                  SizedBox(width: 20),
                  // Alternative sign in (clear icon)
                  IconButton(
                    icon: Icon(Icons.clear, size: 40),
                    onPressed: () {
                      // Alternative sign in logic
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