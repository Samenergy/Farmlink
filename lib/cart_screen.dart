import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'home_screen.dart';
import 'explore_screen.dart';
import 'account_screen.dart';
import 'checkout_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartItems = [];
  double totalCost = 0.0;
  int _selectedIndex = 2; // Default to Cart Tab

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
            imageUrl: data['imageUrl'],
            title: data['title'],
            price: double.tryParse(data['price'].toString()) ?? 0.0,
            quantity: data.containsKey('quantity') ? data['quantity'] : 1,
            id: doc.id,
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
      total += item.price * item.quantity;
    }
    setState(() {
      totalCost = total;
    });
  }

  // Handle item removal from cart
  Future<void> _removeItem(int index) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final item = cartItems[index];

      // Remove item from Firebase
      await FirebaseFirestore.instance
          .collection('basket')
          .doc(item.id)
          .delete();

      // Remove item locally
      setState(() {
        cartItems.removeAt(index);
        _calculateTotalCost(); // Recalculate total cost after removing item
      });
    } catch (e) {
      print('Error removing item: $e');
    }
  }

  // Handle quantity change for an item
  Future<void> _onQuantityChanged(int index, int newQuantity) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final item = cartItems[index];

      // Update quantity in Firebase
      await FirebaseFirestore.instance
          .collection('basket')
          .doc(item.id)
          .update({'quantity': newQuantity});

      // Update quantity locally
      setState(() {
        cartItems[index].quantity = newQuantity;
        _calculateTotalCost(); // Recalculate total cost after quantity change
      });
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  // Handle checkout: Update Firestore with the latest quantities and prices
  Future<void> _checkout() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Update all items in Firestore
      for (var item in cartItems) {
        await FirebaseFirestore.instance.collection('basket').doc(item.id).update({
          'quantity': item.quantity,
          'price': item.price * item.quantity, // Save the total price per item
        });
      }

      // Navigate to the checkout screen
      showModalBottomSheet(
        context: context,
        isScrollControlled: true, // Allows full-screen height if needed
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        builder: (context) => const CheckoutScreen(),
      );
    } catch (e) {
      print('Error during checkout: $e');
    }
  }

  // Handle bottom navigation item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ExploreScreen()),
        );
        break;
      case 2:
        break; // Stay on Cart Screen
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AccountScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'My Cart',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: cartItems.length,
              itemBuilder: (ctx, i) => CartItemWidget(
                cartItem: cartItems[i],
                onRemove: () => _removeItem(i),
                onQuantityChanged: (newQuantity) =>
                    _onQuantityChanged(i, newQuantity),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _checkout, // Checkout updates Firebase
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                minimumSize: const Size(double.infinity, 30),
              ),
              child: const Text(
                'Go to Checkout',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Cost: ${totalCost.toStringAsFixed(2)} Rwf',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class CartItem {
  final String imageUrl;
  final String title;
  final double price;
  int quantity;
  final String id;

  CartItem({
    required this.imageUrl,
    required this.title,
    required this.price,
    this.quantity = 1,
    required this.id,
  });
}

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onRemove;
  final Function(int) onQuantityChanged;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
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
                image: DecorationImage(
                  image: NetworkImage(cartItem.imageUrl),
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
                  const Text(
                    "1kg, Price",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: cartItem.quantity > 1
                            ? () =>
                                onQuantityChanged(cartItem.quantity - 1)
                            : null,
                      ),
                      Text(cartItem.quantity.toString()),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () =>
                            onQuantityChanged(cartItem.quantity + 1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: onRemove, // Remove item
                ),
                Text('${cartItem.price.toStringAsFixed(2)} Rwf'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
