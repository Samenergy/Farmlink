import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'create_post.dart';
import 'dart:convert'; 
import 'dart:typed_data'; 
import 'product_detail_screen.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> userProducts = [];
  List<Map<String, dynamic>> filteredProducts = [];
  String selectedCategory = 'All';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchUserProducts();
  }

  // Fetch only products of the logged-in user
  Future<void> _fetchUserProducts() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('posts')
          .where('user_id', isEqualTo: user.uid)
          .get();

      setState(() {
        userProducts = querySnapshot.docs.map((doc) {
          // Get the first image from the images array
          List<dynamic> images = doc['images'] ?? [];
          String imageBase64 = images.isNotEmpty ? images[0] : '';

          return {
            'id': doc.id,
            'name': doc['product_name'],
            'price': (doc['price'] as num).toInt(), // Ensure price is an int
            'quantity': (doc['quantity'] as num).toInt(), // Ensure quantity is an int
            'imageUrl': imageBase64, // Store the Base64 string
            'description': doc['details'],
          };
        }).toList();
        filteredProducts = List.from(userProducts);
      });
    }
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      filteredProducts = userProducts.where((product) {
        final nameLower = product['name'].toLowerCase();
        final queryLower = query.toLowerCase();
        return nameLower.contains(queryLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the whole screen's background color to white
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'My Products',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: updateSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search for products...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.black),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ProductCard(
                  name: product['name'],
                  quantity: product['quantity'] as int,
                  price: product['price'] as int,
                  imageUrl: product['imageUrl'],
                  description: product['description'],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePostPage()),
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// ProductCard widget inside product_list_page.dart
class ProductCard extends StatelessWidget {
  final String name;
  final int quantity;
  final int price;
  final String imageUrl; // This is your Base64 image string
  final String description;

  const ProductCard({
    super.key,
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    // Decode the Base64 string to bytes
    Uint8List bytes =
        imageUrl.isNotEmpty ? base64Decode(imageUrl) : Uint8List(0);

    return GestureDetector(
      onTap: () {
        // Navigate to ProductDetailPage when tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              name: name,
              quantity: quantity,
              price: price,
              imageUrl: imageUrl,
              description: description,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 150,
                    height: 120,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: imageUrl.isNotEmpty
                        ? Image.memory(bytes,
                            fit: BoxFit.cover) // Use Image.memory for Base64 images
                        : const Icon(Icons.image,
                            size: 60), // Placeholder icon if imageUrl is empty
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text('Quantity Left: $quantity kg',
                              style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text('Price: $price Rwf/Kg',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(description,
                              style: const TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
