import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert'; 
import 'order_accepted_screen.dart';

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

  Future<void> _loadCartItems() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final cartSnapshot = await FirebaseFirestore.instance
          .collection('basket')
          .where('userId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'inprogress')
          .get();

      setState(() {
        cartItems = cartSnapshot.docs.map((doc) {
          final data = doc.data();
          return CartItem(
            id: doc.id,
            postId: data['postId'],
            imageUrl: data['imageUrl'],
            title: data['title'],
            price: double.tryParse(data['price'].toString()) ?? 0.0,
            quantity: data['quantity'] ?? 1,
          );
        }).toList();
        _calculateTotalCost();
      });
    } catch (e) {
      print('Error loading cart items: $e');
    }
  }

  void _calculateTotalCost() {
    double total = 0.0;
    for (var item in cartItems) {
      total += item.price * item.quantity;
    }
    setState(() {
      totalCost = total;
    });
  }

  Future<void> _placeOrder() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final firestore = FirebaseFirestore.instance;

      for (var cartItem in cartItems) {
        await firestore.collection('basket').doc(cartItem.id).update({
          'status': 'done',
        });

        final postDoc = firestore.collection('posts').doc(cartItem.postId);
        final postSnapshot = await postDoc.get();
        if (postSnapshot.exists) {
          final currentQuantity = postSnapshot.data()?['quantity'] ?? 0;
          final updatedQuantity = currentQuantity - cartItem.quantity;
          await postDoc.update({
            'quantity': updatedQuantity < 0 ? 0 : updatedQuantity,
          });
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully!')),
      );

      // Clear the cart and navigate to OrderAcceptedScreen
      setState(() {
        cartItems.clear();
        totalCost = 0.0;
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const OrderAcceptedScreen()),
      );
    } catch (e) {
      print('Error placing order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          _buildCheckoutSummary(screenWidth),
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
            onPressed: _placeOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              minimumSize: Size(screenWidth * 0.8, 50),
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
  final String id;
  final String postId;
  final String imageUrl;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    required this.id,
    required this.postId,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.quantity,
  });
}

class CheckoutItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CheckoutItemWidget({Key? key, required this.cartItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  decodedImage,
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
