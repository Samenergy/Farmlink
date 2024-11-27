import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'account_screen.dart';
import 'product_details_screen.dart'; // Import the product detail screen

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _currentIndex = 1; // Default to Explore tab
  final user = FirebaseAuth.instance.currentUser; // Access the current user
  final List<Widget> _screens = [
    const HomeScreen(),
    const ExploreScreen(), // The current explore page
    const CartScreen(),
    const AccountScreen(),
  ];
  String _searchTerm = '';
  String? _selectedCategory;
  bool _isLoading = false;
  List<Map<String, dynamic>> _searchResults = [];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate to the selected screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _screens[index]),
    );
  }

  Future<void> _searchProducts(String query) async {
    setState(() {
      _isLoading = true;
      _searchResults = [];
      _selectedCategory = null;
    });

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('product_name', isGreaterThanOrEqualTo: query)
          .where('product_name', isLessThanOrEqualTo: '${query}z')
          .get();

      setState(() {
        _searchResults = querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _filterByCategory(String category) async {
    setState(() {
      _isLoading = true;
      _searchResults = [];
      _selectedCategory = category;
    });

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('category', isEqualTo: category)
          .get();

      setState(() {
        _searchResults = querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Find Products',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: (value) {
                      _searchTerm = value;
                      if (value.isNotEmpty) {
                        _searchProducts(value);
                      } else {
                        setState(() {
                          _searchResults = [];
                          _selectedCategory = null;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Search Store',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product Results Grid or Categories
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (_searchResults.isEmpty && _selectedCategory == null)
                      ? GridView.count(
                          crossAxisCount: 2,
                          padding: const EdgeInsets.all(16),
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          children: [
                            CategoryCard(
                              title: 'Vegetables',
                              imagePath: 'assets/vegetables.png',
                              onTap: () => _filterByCategory('Vegetables'),
                            ),
                            CategoryCard(
                              title: 'Fruits',
                              imagePath: 'assets/fruit.png',
                              onTap: () => _filterByCategory('Fruits'),
                            ),
                            CategoryCard(
                              title: 'Meat & Fish',
                              imagePath: 'assets/meat.png',
                              onTap: () => _filterByCategory('Meat & Fish'),
                            ),
                            CategoryCard(
                              title: 'Nuts',
                              imagePath: 'assets/nuts.png',
                              onTap: () => _filterByCategory('Nuts & Seeds'),
                            ),
                            CategoryCard(
                              title: 'Dairy & Eggs',
                              imagePath: 'assets/eggs.png',
                              onTap: () => _filterByCategory('Dairy & Eggs'),
                            ),
                            CategoryCard(
                              title: 'Cereals',
                              imagePath: 'assets/cereal.png',
                              onTap: () => _filterByCategory('Cereals'),
                            ),
                          ],
                        )
                      : _searchResults.isEmpty
                          ? const Center(child: Text('No products found.'))
                          : GridView.builder(
                              padding: const EdgeInsets.all(16),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                              ),
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final product = _searchResults[index];

                                // Check if images field is a list and use the first image if available
                                final imageField = product['images'];
                                Uint8List? imageBytes;
                                if (imageField is List &&
                                    imageField.isNotEmpty) {
                                  imageBytes = base64Decode(
                                      imageField[0]); // Use the first image
                                } else if (imageField is String) {
                                  imageBytes = base64Decode(
                                      imageField); // Use single image string
                                }

                                return ProductCard(
                                  name: product['product_name'] ?? 'Unknown',
                                  imageBytes: imageBytes ??
                                      Uint8List(0), // Handle null case
                                  price: product['price']?.toString() ?? '0',
                                  product: product, // Pass the whole product
                                );
                              },
                            ),
            ),

            // Bottom Navigation Bar
            BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: 'Cart',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final Uint8List imageBytes;
  final String price;
  final Map<String, dynamic> product;

  const ProductCard({
    super.key,
    required this.name,
    required this.imageBytes,
    required this.price,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    // Get the images field from product
    final imageField = product['images'];

    // Check if imageField is a list or a single string and handle accordingly
    Uint8List? imageBytes;
    if (imageField is List && imageField.isNotEmpty) {
      // If the images field is a list, we use the first image in the list
      imageBytes = base64Decode(imageField[0]);
    } else if (imageField is String) {
      // If the images field is a single base64 string
      imageBytes = base64Decode(imageField);
    }

    return GestureDetector(
      onTap: () {
        // Navigate to ProductDetailScreen with the necessary data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              imageUrl:
                  product['images']?[0]  ?? '', // Pass the image URL or empty string
              price: price,
              title: name,
              details: product['details'] ?? 'No description available.',
              category: product['category'] ?? 'Unknown',
              postId: product['postId'] ?? '',
              quantity: product['quantity']?.toInt() ?? '',
              status: product['status'] ?? '',
            ),
          ),
        );
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey[300]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageBytes != null
                ? Image.memory(
                    imageBytes,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.image, size: 120), // Fallback if no image
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Price: \$$price',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
