import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                OnboardingPage(
                  image: 'assets/farmer.jpeg',
                  title: 'As a Farmer',
                  description:
                      'Sell your produce online and reach more buyers. Start earning from your harvest.',
                  buttonText: 'Sell with us',
                ),
                OnboardingPage(
                  image: 'assets/buyer.jpg',
                  title: 'As a Buyer',
                  description:
                      'Consumers can discover a wide range of fresh produce directly from farmers.',
                  buttonText: 'Explore Now',
                ),
                OnboardingPage(
                  image: 'assets/partner.jpg',
                  title: 'As a Partner',
                  description:
                      'Get products delivered fast with reliable transport partners.',
                  buttonText: 'Get Started',
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                width: _currentPage == index ? 12.0 : 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.black : Colors.grey,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to next screen or dashboard
                print('Onboarding completed');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'Done',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String buttonText;

  OnboardingPage({
    required this.image,
    required this.title,
    required this.description,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8.0), // Padding for the border
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Image.asset(image, height: 250, fit: BoxFit.cover),
            ),
            SizedBox(height: 40),
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                print('$buttonText pressed');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                minimumSize: Size(200, 50),
              ),
              child: Text(
                buttonText,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
