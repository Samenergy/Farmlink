import 'package:flutter/material.dart';

class HowToFarmScreen extends StatefulWidget {
  const HowToFarmScreen({super.key});

  @override
  _HowToFarmScreenState createState() => _HowToFarmScreenState();
}

class _HowToFarmScreenState extends State<HowToFarmScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home'); // Navigate to HomeScreen
            },
            child: const Text(
              'Skip',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              "Discover the freshest picks from local farms",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: const [
                HowToPage(
                  image: 'assets/step1farm.png',
                  title: 'Step 1',
                  description: 'Add products with photos, descriptions, and prices.',
                  showButton: false,
                ),
                HowToPage(
                  image: 'assets/step2farm.png',
                  title: 'Step 2',
                  description: 'Choose delivery methods or pickup points.',
                  showButton: false,
                ),
                HowToPage(
                  image: 'assets/step3farm.png',
                  title: 'Step 3',
                  description: 'Confirm and prepare incoming orders.',
                  showButton: true, // Show button on last step
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                width: _currentPage == index ? 12.0 : 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.black : Colors.grey,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class HowToPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final bool showButton;

  const HowToPage({super.key, 
    required this.image,
    required this.title,
    required this.description,
    required this.showButton,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            ClipOval(
              child: Image.asset(
                image,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 32),
            if (showButton)
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home'); // Navigate to HomeScreen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  minimumSize: const Size(200, 50),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
