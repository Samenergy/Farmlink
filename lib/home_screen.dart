import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'product_provider.dart'; // Import the product provider
import 'explore_screen.dart';
import 'cart_screen.dart';
import 'account_screen.dart';
import 'product_details_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String selectedCategory = 'All'; // Default selected category

  // Function to filter products by category
  List<Product> getFilteredProducts(List<Product> products) {
    if (selectedCategory == 'All') {
      return products; // Show all products
    }
    return products
        .where((product) => product.category == selectedCategory)
        .toList(); // Filter products by category
  }

  @override
  Widget build(BuildContext context) {
    final productsAsyncValue =
        ref.watch(productListProvider); // Watch Firestore product data

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Image.asset(
            'assets/farmlink_logo.png',
            height: 100,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.black),
              onPressed: () {
                // Add action for favorites
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Horizontal Category Filter
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CategoryButton(
                      label: 'All',
                      selected: selectedCategory == 'All',
                      onTap: () {
                        setState(() {
                          selectedCategory = 'All'; // Update selected category
                        });
                      },
                    ),
                    CategoryButton(
                      label: 'Vegetables',
                      selected: selectedCategory == 'Vegetables',
                      onTap: () {
                        setState(() {
                          selectedCategory =
                              'Vegetables'; // Update selected category
                        });
                      },
                    ),
                    CategoryButton(
                      label: 'Fruits',
                      selected: selectedCategory == 'Fruits',
                      onTap: () {
                        setState(() {
                          selectedCategory =
                              'Fruits'; // Update selected category
                        });
                      },
                    ),
                    CategoryButton(
                      label: 'Grains',
                      selected: selectedCategory == 'Grains',
                      onTap: () {
                        setState(() {
                          selectedCategory =
                              'Grains'; // Update selected category
                        });
                      },
                    ),
                    // Add more CategoryButton widgets for more categories if needed
                  ],
                ),
              ),
              // Product Grid Section
              productsAsyncValue.when(
                data: (products) {
                  final filteredProducts = getFilteredProducts(products);
                  return filteredProducts.isEmpty
                      ? const Center(child: Text('No products available'))
                      : SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: GridView.builder(
                            padding: const EdgeInsets.all(10.0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                              childAspectRatio: 0.9,
                            ),
                            itemCount: filteredProducts.length,
                            itemBuilder: (ctx, i) => ProductItem(
                              filteredProducts[i].decodedImage,
                              filteredProducts[i].name,
                              filteredProducts[i].price.toString(),
                              product: filteredProducts[
                                  i], // Passing the full product
                            ),
                          ),
                        );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
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
              label: 'Profile',
            ),
          ],
          currentIndex: 0,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            switch (index) {
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ExploreScreen()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
                break;
              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AccountScreen()),
                );
                break;
            }
          },
        ),
      ),
    );
  }
}

// CategoryButton widget definition
class CategoryButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const CategoryButton({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: onTap, // Handle category selection
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF000000) : Colors.grey[300],
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: selected ? const Color(0xFF000000) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    );
  }
}

// Product Item widget definition
class ProductItem extends StatelessWidget {
  final ImageProvider imageProvider;
  final String name;
  final String price;
  final Product product; // Receiving the full product object

  const ProductItem(this.imageProvider, this.name, this.price,
      {super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              imageUrl: product.imageUrl,
              title: name,
              price: price,
              category: product.category,
              details: product.details,
              quantity: product.quantity,
              status: product.status,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image(
                  image: imageProvider,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5.0),
              Text(
                '$price Rwf/Kg',
                style: const TextStyle(color: Color(0xFF000000)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
