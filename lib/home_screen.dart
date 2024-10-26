import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'product_provider.dart'; // Import product providers and model
import 'explore_screen.dart';
import 'cart_screen.dart';
import 'account_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productListProvider); // Watch product state

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Remove back icon
          title: Image.asset(
            'assets/farmlink_logo.png', // Replace with your logo image path
            height: 100,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.black),
              onPressed: () {
                // Add your action for favorites
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
                      selected: ref.watch(productCategoryProvider) == 'All',
                      onTap: () => filterProducts(ref, 'All'),
                    ),
                    CategoryButton(
                      label: 'Vegetables',
                      selected: ref.watch(productCategoryProvider) == 'Vegetables',
                      onTap: () => filterProducts(ref, 'Vegetables'),
                    ),
                    CategoryButton(
                      label: 'Fruits',
                      selected: ref.watch(productCategoryProvider) == 'Fruits',
                      onTap: () => filterProducts(ref, 'Fruits'),
                    ),
                    CategoryButton(
                      label: 'Cereals',
                      selected: ref.watch(productCategoryProvider) == 'Cereals',
                      onTap: () => filterProducts(ref, 'Cereals'),
                    ),
                    CategoryButton(
                      label: 'Nuts',
                      selected: ref.watch(productCategoryProvider) == 'Nuts',
                      onTap: () => filterProducts(ref, 'Nuts'),
                    ),
                    CategoryButton(
                      label: 'Flour',
                      selected: ref.watch(productCategoryProvider) == 'Flour',
                      onTap: () => filterProducts(ref, 'Flour'),
                    ),
                  ],
                ),
              ),
              // Product Grid Section
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: products.length,
                  itemBuilder: (ctx, i) => ProductItem(
                    products[i].imageUrl,
                    products[i].title,
                    products[i].price,
                  ),
                ),
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

class CategoryButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const CategoryButton({
    super.key,
    required this.label,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          foregroundColor: selected ? Colors.white : Colors.black,
          backgroundColor: selected ? Colors.black : Colors.white,
          side: const BorderSide(color: Colors.black),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;

  const ProductItem(this.imageUrl, this.title, this.price, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              imageUrl: imageUrl,
              title: title,
              price: price,
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
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      imageUrl,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: const Icon(
                      Icons.favorite_border,
                      size: 20,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$price Rwf/Kg',
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
