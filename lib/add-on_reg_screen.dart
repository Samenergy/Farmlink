// add_on_reg_screen.dart

import 'package:flutter/material.dart';

class AddOnRegistrationScreen extends StatelessWidget {
  static const routeName = '/add-on-registration';

  const AddOnRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with Skip button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Skip registration and go to main app
                        Navigator.pushReplacementNamed(context, '/main');
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Main title
                const Text(
                  'Discover the freshest\npicks from local\nfarms',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Consumers section
                const Text(
                  'How it works for Consumers',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // Consumer steps
                Row(
                  children: [
                    Expanded(
                      child: _buildStepCard(
                        image: 'assets/consumer_step1.jpg',
                        stepNumber: '1',
                        description:
                            'Search or explore fresh produce available from nearby farmers.',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStepCard(
                        image: 'assets/consumer_step2.jpg',
                        stepNumber: '2',
                        description: 'Select items and view details',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Farmers section
                const Text(
                  'How it works for Farmers',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // Farmer steps
                Row(
                  children: [
                    Expanded(
                      child: _buildStepCard(
                        image: 'assets/farmer_step1.jpg',
                        stepNumber: '1',
                        description:
                            'Add products with photos, descriptions, and prices',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStepCard(
                        image: 'assets/farmer_step2.jpg',
                        stepNumber: '2',
                        description: 'Choose delivery or pickup',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Start button
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the main app after registration
                    Navigator.pushReplacementNamed(context, '/main');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Start',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepCard({
    required String image,
    required String stepNumber,
    required String description,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Step $stepNumber',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
