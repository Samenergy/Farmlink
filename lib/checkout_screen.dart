import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back navigation
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Handle cart action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCartItem(context, 'Watermelon', '1kg', 500),
            const SizedBox(height: 16),
            _buildCartItem(context, 'Cabbages', '1kg', 200), // Add more items as necessary

            const Spacer(),

            // Checkout Summary
            _buildCheckoutSummary(context),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton(
            onPressed: () {
              // Handle place order action
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.black, // Button color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Place Order',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, String title, String weight, int price) {
    return Row(
      children: [
        Image.network(
          'https://via.placeholder.com/150', // Placeholder for the image
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(weight),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            IconButton(
              onPressed: () {
                // Handle quantity decrement
              },
              icon: const Icon(Icons.remove),
            ),
            const Text('1'), // Display quantity
            IconButton(
              onPressed: () {
                // Handle quantity increment
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        Text('$price Rwf'),
      ],
    );
  }

  Widget _buildCheckoutSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: const Text('Delivery'),
            trailing: const Text('Select Method'),
            onTap: () {
              // Handle delivery method selection
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Payment'),
            trailing: const Icon(Icons.payment, color: Colors.blue),
            onTap: () {
              // Handle payment method selection
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Promo Code'),
            trailing: const Text('Pick discount'),
            onTap: () {
              // Handle promo code selection
            },
          ),
          const Divider(),
          const ListTile(
            title: Text('Total Cost'),
            trailing: Text(
              '700 Rwf',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'By placing an order you agree to our Terms and Conditions',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}