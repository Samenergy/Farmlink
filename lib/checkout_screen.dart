import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert'; // For decoding base64 string

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  List<CartItem> cartItems = [];
  double totalCost = 0.0;
  String selectedDeliveryMethod = 'Standard Delivery';

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  // Load cart items from Firestore
  Future<void> _loadCartItems() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return; // If the user is not logged in, do not load cart items
      }

      final cartSnapshot = await FirebaseFirestore.instance
          .collection('basket')
          .where('userId', isEqualTo: user.uid)
          .get();

      setState(() {
        cartItems = cartSnapshot.docs.map((doc) {
          final data = doc.data();
          return CartItem(
            imageUrl: data['imageUrl'], // Base64 string from Firestore
            title: data['title'],
            price: double.tryParse(data['price'].toString()) ?? 0.0,
            quantity: data['quantity'] ?? 1,
          );
        }).toList();
        _calculateTotalCost(); // Recalculate total cost after loading cart items
      });
    } catch (e) {
      print('Error loading cart items: $e');
    }
  }

  // Calculate total cost based on quantity and price
  void _calculateTotalCost() {
    double total = 0.0;
    for (var item in cartItems) {
      total += item.price *
          item.quantity; // Correct the calculation to sum all item prices
    }
    setState(() {
      totalCost = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: cartItems.isEmpty
                ? const Center(
                    child: Text(
                      'No items in your cart.',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: cartItems.length,
                    itemBuilder: (ctx, i) => CheckoutItemWidget(
                      cartItem: cartItems[i],
                    ),
                  ),
          ),
          _buildCheckoutSummary(
              screenWidth), // Pass screenWidth to summary for responsiveness
        ],
      ),
    );
  }

  Widget _buildCheckoutSummary(double screenWidth) {
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
            trailing: DropdownButton<String>(
              value: selectedDeliveryMethod,
              onChanged: (newValue) {
                setState(() {
                  selectedDeliveryMethod = newValue!;
                });
              },
              items: <String>['Standard Delivery', 'Express Delivery']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
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
          ListTile(
            title: const Text('Total Cost'),
            trailing: Text(
              '${totalCost.toStringAsFixed(2)} Rwf',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'By placing an order you agree to our Terms and Conditions',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Implement place order functionality
              print("Order placed successfully!");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              minimumSize: Size(
                  screenWidth * 0.8, 50), // Responsive width for the button
            ),
            child: const Text(
              'Place Order',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class CartItem {
  final String imageUrl;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.quantity,
  });
}

class CheckoutItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CheckoutItemWidget({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Decode the base64 string into bytes
    final decodedImage = base64Decode(cartItem.imageUrl);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  decodedImage, // Use Image.memory to display the base64 image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Quantity: ${cartItem.quantity}',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${cartItem.price.toStringAsFixed(2)} Rwf',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
