import 'package:flutter/material.dart';
import 'how-to_screen.dart'; // Import the HowToScreen
import 'how-to_farm.dart'; // Import the HowToFarmScreen

class UserTypeScreen extends StatefulWidget {
  const UserTypeScreen({super.key});

  @override
  _UserTypeScreenState createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends State<UserTypeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HowToFarmScreen()),
                        );
                      },
                    ),
                    UserTypePage(
                      image: 'assets/buyer.jpg',
                      title: 'As a Buyer',
                      description:
                          'FarmLink connects you with fresh produce. Easy ordering, and more. Shop conveniently online.',
                      buttonText: 'Buy with Us',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HowToScreen()),
                        );
                      },
                    ),
                    UserTypePage(
                      image: 'assets/partner.jpg',
                      title: 'As a Partner',
                      description:
                          'Join us in revolutionizing farm-to-table deliveries.',
                      buttonText: 'Partner with us',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HowToScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Dots Indicator
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      width: _currentPage == index ? 12.0 : 8.0,
                      height: 8.0,
                      decoration: BoxDecoration(
                        color:
                            _currentPage == index ? Colors.black : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class UserTypePage extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onPressed;

  const UserTypePage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            'assets/farmlink_logo.png',
            height: screenHeight * 0.15, // 15% of screen height
          ),
          ClipOval(
            child: Image.asset(
              image,
              height: screenHeight * 0.25, // 25% of screen height
              width: screenHeight * 0.25,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              minimumSize: const Size(200, 50),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
