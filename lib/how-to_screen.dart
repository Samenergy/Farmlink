import 'package:flutter/material.dart';

class HowToScreen extends StatefulWidget {
  @override
  _HowToScreenState createState() => _HowToScreenState();
}

class _HowToScreenState extends State<HowToScreen> {
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
              Navigator.pushReplacementNamed(context, '/home'); // Adjust route as needed
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
              children: [
                HowToPage(
                  image: 'assets/buyer.jpg',
                  title: 'Step 1',
                  description:
                      'Search or explore fresh produce available from nearby farmers.',
                  showButton: false,
                ),
                HowToPage(
                  image: 'assets/buyer.jpg',
                  title: 'Step 2',
                  description:
                      'Select products, add delivery details, and choose a payment method.',
                  showButton: false,
                ),
                HowToPage(
                  image: 'assets/partner.jpg',
                  title: 'Step 3',
                  description:
                      'Monitor delivery status and get real-time updates.',
                  showButton: true,
                ),
              ],
            ),
          ),
          // Dots Indicator
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

  HowToPage({
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
                  Navigator.pushReplacementNamed(context, '/home'); // Adjust route as needed
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
