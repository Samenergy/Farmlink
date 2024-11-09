import 'package:flutter/material.dart';
import 'create_post.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Map<String, dynamic>> products = [
    {
      'name': 'Red Apples',
      'price': 3.00,
      'quantity': 78.0,
      'imageUrl': 'assets/apple.jpg',
      'description': 'Fresh and juicy red apples'
    },
    {
      'name': 'Bananas',
      'price': 1.20,
      'quantity': 10.0,
      'imageUrl': 'assets/banana.jpg',
      'description': 'Delicious ripe bananas'
    },
    {
      'name': 'Carrots',
      'price': 2.50,
      'quantity': 8.0,
      'imageUrl': 'assets/carrot.jpg',
      'description': 'Organic and fresh carrots'
    },
    {
      'name': 'Watermelon',
      'price': 2.00,
      'quantity': 2.0,
      'imageUrl': 'assets/watermelon.jpg',
      'description': 'Sweet and juicy watermelon'
    },
  ];

  List<Map<String, dynamic>> filteredProducts = [];
  String selectedCategory = 'All';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredProducts = products;
  }

  void updateCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      filteredProducts = products
          .where((product) =>
              product['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Row(
          children: [
            const SizedBox(width: 8),
            const Text(
              'All Products',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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
                  borderSide: const BorderSide(color: Color(0xFF018241)),
                ),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF018241)),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CategoryTab(
                  label: 'All',
                  isSelected: selectedCategory == 'All',
                  onTap: () => updateCategory('All'),
                ),
                CategoryTab(
                  label: 'On Sales',
                  isSelected: selectedCategory == 'On Sales',
                  onTap: () => updateCategory('On Sales'),
                ),
                CategoryTab(
                  label: 'Sold',
                  isSelected: selectedCategory == 'Sold',
                  onTap: () => updateCategory('Sold'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ProductCard(
                  name: product['name'],
                  quantity: product['quantity'],
                  price: product['price'],
                  imageUrl: product['imageUrl'],
                  description: product['description'],
                );
              },
            ),
          ),
        ],
      ),
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePostPage()),
          );
        },
        backgroundColor: Colors.black, // Black background color
        child: const Icon(
          Icons.add,
          color: Colors.white, // White icon color
        ),
      ),
    );
  }
}

class CategoryTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function onTap;

  const CategoryTab({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? const Color(0xFF000000) : Colors.black,
              fontSize: 16,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 3,
              width: 30,
              color: const Color(0xFF000000),
            ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final double quantity;
  final double price;
  final String imageUrl;
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
    return Container(
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
        border: Border.all(color: const Color(0xFF000000)),
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
                    border: Border.all(color: const Color(0xFF0F0F0F)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: 150,
                      height: 120,
                    ),
                  ),
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
                                color: Color(0xFF000000),
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
            Container(
              margin: const EdgeInsets.only(top: 0, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF000000),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                    ),
                    child: const Text('Edit'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF000000),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                    ),
                    child: const Text('Remove'),
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
