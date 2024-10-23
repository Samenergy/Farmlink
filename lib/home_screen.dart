import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farmlink', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {
              // Add action
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CategoryButton(label: 'All', selected: true),
                CategoryButton(label: 'Vegetables'),
                CategoryButton(label: 'Fruits'),
                CategoryButton(label: 'Cereals'),
                CategoryButton(label: 'Nuts'),
                CategoryButton(label: 'Flour'),
              ],
            ),
          ),
          // Product Grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 0.7,
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
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
        currentIndex: 0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // Add action
        },
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String label;
  final bool selected;

  CategoryButton({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () {
          // Add action for filtering
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: selected ? Colors.white : Colors.black, backgroundColor: selected ? Colors.black : Colors.white,
          side: BorderSide(color: Colors.black),
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

  ProductItem(this.imageUrl, this.title, this.price);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 2,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  '$price Rwf/Kg',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    onPressed: () {
                      // Add to cart
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Example product data
final List<Product> products = [
  Product('https://example.com/bananas.jpg', 'Bananas', '150'),
  Product('https://example.com/apple.jpg', 'Apple', '200'),
  Product('https://example.com/spinach.jpg', 'Spinach', '500'),
  Product('https://example.com/tomatoes.jpg', 'Tomatoes', '500'),
  Product('https://example.com/potatoes.jpg', 'Potatoes', '1500'),
  Product('https://example.com/vegetables.jpg', 'Vegetables', '600'),
  Product('https://example.com/watermelon.jpg', 'Watermelons', '200'),
  Product('https://example.com/maize.jpg', 'Maize', '200'),
  Product('https://example.com/bean.jpg', 'Bean', '300'),
  // Add more products as needed
];

class Product {
  final String imageUrl;
  final String title;
  final String price;

  Product(this.imageUrl, this.title, this.price);
}