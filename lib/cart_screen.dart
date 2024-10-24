import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'explore_screen.dart';
import 'account_screen.dart';
import 'checkout_screen.dart'; // Import your CheckoutScreen here

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<CartItem> cartItems = [
    CartItem('assets/tomato.jpg', 'Tomatoes', '1,000'),
    CartItem('assets/apple.jpg', 'Apples', '1,000'),
    CartItem('assets/maize.jpg', 'Maize', '1,000'),
    CartItem('assets/watermelon.jpg', 'Watermelons', '1,000'),
    CartItem('assets/carrot.jpg', 'Carrots', '1,000'),
  ];

  int _selectedIndex = 2; // Default to Cart Tab

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
        // Stay on the Cart Screen
        break;
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
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Add search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
            onPressed: () {
              // Navigate to cart
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: cartItems.length,
              itemBuilder: (ctx, i) => CartItemWidget(
                cartItem: cartItems[i],
                onRemove: () {
                  setState(() {
                    cartItems.removeAt(i);
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Show CheckoutScreen as a modal bottom sheet
                showModalBottomSheet(
                  context: context,
                  isScrollControlled:
                      true, // Allows full-screen height if needed
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  builder: (context) =>
                      const CheckoutScreen(), // Display the CheckoutScreen here
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                minimumSize: const Size(double.infinity, 30), // Full width
              ),
              child: const Text(
                'Go to Checkout',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white, // White font color
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
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
  final String price;
  int quantity;

  CartItem(this.imageUrl, this.title, this.price, {this.quantity = 1});
}

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onRemove;

  const CartItemWidget(
      {super.key, required this.cartItem, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Product Image
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
            // Product Details
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
                  // Quantity Selector
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: cartItem.quantity > 1
                            ? () {
                                // Decrease quantity
                              }
                            : null,
                      ),
                      Text(
                        '${cartItem.quantity}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          // Increase quantity
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Price and Remove Button
            Column(
              children: [
                Text(
                  "${cartItem.price} Rwf",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: onRemove,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
