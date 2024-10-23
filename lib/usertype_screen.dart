import 'package:flutter/material.dart';
import 'how-to_screen.dart'; // Import the HowToScreen

class UserTypeScreen extends StatefulWidget {
  @override
  _UserTypeScreenState createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends State<UserTypeScreen> {
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
                UserTypePage(
                  image: 'assets/farmer.jpeg',
                  title: 'As a Farmer',
                  description:
                      'Sell your produce online and reach more buyers. Start earning from your harvest.',
                  buttonText: 'Sell with us',
                ),
                UserTypePage(
                  image: 'assets/buyer.jpg',
                  title: 'As a Buyer',
                  description:
                      'FarmLink connects you with fresh produce. Easy ordering, and more. Shop conveniently online.',
                  buttonText: 'Buy with Us',
                ),
                UserTypePage(
                  image: 'assets/partner.jpg',
                  title: 'As a Partner',
                  description:
                      'Join us in revolutionizing farm-to-table deliveries.',
                  buttonText: 'Partner with us',
                ),
              ],
            ),
          ),
          // Dots Indicator
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
        ],
      ),
    );
  }
}

class UserTypePage extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String buttonText;

  UserTypePage({
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
          children: [
            // Space for logo at the top
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Image.asset(
                'assets/farmlink_logo.png', // Replace with your logo asset path
                height: 200,
              ),
            ),
            // Circular Image
            ClipOval(
              child: Image.asset(
                image,
                height: 200,
                width: 200, // Ensures the image is perfectly circular
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
            ElevatedButton(
              onPressed: () {
                // Navigate to HowToScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HowToScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                minimumSize: const Size(200, 50),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
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
