import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = []; // To store the selected products
  double totalCost = 0;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  // Load the cart items from Firestore
  // Load the cart items from Firestore
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

      cartItems = cartSnapshot.docs.map((doc) {
        // Get data from Firestore document
        final data = doc.data();
        return {
          'id': doc.id,
          'category': data['category'],
          'details': data['details'],
          'imageUrl': data['imageUrl'],
          'price': double.tryParse(data['price'] ?? '0') ?? 0.0,
          'status': data['status'],
          'title': data['title'],
          // Check if 'quantity' exists, otherwise default to 1
          'quantity': data.containsKey('quantity') ? data['quantity'] : 1,
        };
      }).toList();

      _calculateTotalCost();
      setState(() {});
    } catch (e) {
      // Handle any errors while fetching the cart items
      print('Error loading cart items: $e');
    }
  }

  // Calculate the total cost based on the quantity and price
  void _calculateTotalCost() {
    totalCost = 0;
    for (var item in cartItems) {
      totalCost += item['price'] * item['quantity'];
    }
  }

  // Update the quantity of a product
  void _updateQuantity(String itemId, int quantity) {
    setState(() {
      final index = cartItems.indexWhere((item) => item['id'] == itemId);
      if (index != -1) {
        cartItems[index]['quantity'] = quantity;
      }
      _calculateTotalCost();
    });

    // Optionally update Firestore to reflect the change
    FirebaseFirestore.instance.collection('basket').doc(itemId).update({
      'quantity': quantity,
    });
  }

  // Remove product from the cart
  void _removeFromCart(String itemId) {
    setState(() {
      cartItems.removeWhere((item) => item['id'] == itemId);
      _calculateTotalCost();
    });

    // Optionally remove the product from Firestore
    FirebaseFirestore.instance.collection('basket').doc(itemId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              setState(() {
                cartItems.clear();
                totalCost = 0;
              });
              FirebaseFirestore.instance
                  .collection('basket')
                  .where('userId',
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .get()
                  .then((snapshot) {
                for (var doc in snapshot.docs) {
                  doc.reference.delete();
                }
              });
            },
          ),
        ],
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return CartItemWidget(
                  item: item,
                  onQuantityChanged: (quantity) =>
                      _updateQuantity(item['id'], quantity),
                  onRemove: () => _removeFromCart(item['id']),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: \$${totalCost.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Proceed to checkout
                  Navigator.pushNamed(context, '/checkout');
                },
                child: const Text('Proceed to Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final Map<String, dynamic> item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Image.memory(
          base64Decode(item['imageUrl']),
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(item['title']),
        subtitle: Text('Price: \$${item['price']}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: item['quantity'] > 1
                  ? () => onQuantityChanged(item['quantity'] - 1)
                  : null,
            ),
            Text(item['quantity'].toString()),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => onQuantityChanged(item['quantity'] + 1),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}
