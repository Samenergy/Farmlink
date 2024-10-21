import 'package:flutter/material.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 80.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo at the top (increased size to 120)
              Image.asset(
                'assets/farmlink_logo.png',
                height: 200,
              ),
              const SizedBox(height: 30),

              // Title
              const Text(
                'Login to your account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              // Email Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Password Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),

              // Login Button with white text color
              ElevatedButton(
                onPressed: () {
                  // Handle login functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,  // Changed font color to white
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Forgot Password
              TextButton(
                onPressed: () {
                  // Forgot password functionality
                },
                child: const Text(
                  'Forgot your password?',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Or sign in with
              const Text('Or Sign in with'),
              const SizedBox(height: 10),

              // Social Media Icons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/icons/google_icon.png',
                      height: 40,
                    ),
                    onPressed: () {
                      // Google login functionality
                    },
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: Image.asset(
                      'assets/icons/facebook_icon.png',
                      height: 40,
                    ),
                    onPressed: () {
                      // Facebook login functionality
                    },
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: Image.asset(
                      'assets/icons/instagram_icon.png',
                      height: 40,
                    ),
                    onPressed: () {
                      // Instagram login functionality
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Signup Redirect
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don’t have an account? '),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Signup',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
