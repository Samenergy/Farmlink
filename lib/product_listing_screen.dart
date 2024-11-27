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
  List<Map<String, dynamic>> allProducts = [];
  List<Map<String, dynamic>> onSaleProducts = [];
  List<Map<String, dynamic>> soldProducts = [];
  List<Map<String, dynamic>> displayedProducts = [];
  String selectedSection = 'All';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      // Fetch all user products
      final QuerySnapshot postsSnapshot = await _firestore
          .collection('posts')
          .where('user_id', isEqualTo: user.uid)
          .get();

      // Fetch products On Sale
      final QuerySnapshot onSaleSnapshot = await _firestore
          .collection('posts')
          .where('user_id', isEqualTo: user.uid)
          .where('status', isEqualTo: 'OnSale')
          .get();

      // Fetch Sold products
      final QuerySnapshot soldSnapshot = await _firestore
          .collection('basket')
          .where('userId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'done')
          .get();

      setState(() {
        allProducts =
            postsSnapshot.docs.map((doc) => _productFromDoc(doc)).toList();
        onSaleProducts =
            onSaleSnapshot.docs.map((doc) => _productFromDoc(doc)).toList();
        soldProducts =
            soldSnapshot.docs.map((doc) => _productFromDoc(doc)).toList();
        _updateDisplayedProducts();
      });
    }
  }

  Map<String, dynamic> _productFromDoc(QueryDocumentSnapshot doc) {
    List<dynamic> images = doc['images'] ?? [];
    String imageBase64 = images.isNotEmpty ? images[0] : '';

    return {
      'id': doc.id,
      'productId': doc.id,
      'name': doc['product_name'],
      'price': (doc['price'] as num).toInt(),
      'quantity': (doc['quantity'] as num).toInt(),
      'imageUrl': imageBase64,
      'description': doc['details'],
    };
  }

  void _updateDisplayedProducts() {
    List<Map<String, dynamic>> products;
    if (selectedSection == 'All') {
      products = allProducts;
    } else if (selectedSection == 'On Sale') {
      products = onSaleProducts;
    } else {
      products = soldProducts;
    }

    setState(() {
      displayedProducts = products.where((product) {
        final nameLower = product['name'].toLowerCase();
        final queryLower = searchQuery.toLowerCase();
        return nameLower.contains(queryLower);
      }).toList();
    });
  }

  void _onSectionChanged(String section) {
    setState(() {
      selectedSection = section;
      _updateDisplayedProducts();
    });
  }

  void _updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      _updateDisplayedProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              onChanged: _updateSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search for products...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _sectionButton('All'),
                _sectionButton('On Sale'),
                _sectionButton('Sold'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayedProducts.length,
              itemBuilder: (context, index) {
                final product = displayedProducts[index];
                return ProductCard(
                  productId: product['productId'],
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

  Widget _sectionButton(String section) {
    final isSelected = section == selectedSection;
    return ElevatedButton(
      onPressed: () => _onSectionChanged(section),
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : Colors.black,
        backgroundColor: isSelected ? Colors.black : Colors.grey[300],
      ),
      child: Text(section),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String productId;
  final String name;
  final int quantity;
  final int price;
  final String imageUrl;
  final String description;

  const ProductCard({
    super.key,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    Uint8List bytes =
        imageUrl.isNotEmpty ? base64Decode(imageUrl) : Uint8List(0);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              productId: productId,
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
          child: Row(
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
                    ? Image.memory(bytes, fit: BoxFit.cover)
                    : const Icon(Icons.image),
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
        ),
      ),
    );
  }
}
