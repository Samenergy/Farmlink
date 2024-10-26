import 'package:flutter_riverpod/flutter_riverpod.dart';

// Product Model
class Product {
  final String imageUrl;
  final String title;
  final String price;
  final String category;

  Product({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.category,
  });
}

// List of all products
final List<Product> allProducts = [
  Product(imageUrl: 'assets/banana.jpg', title: 'Bananas', price: '150', category: 'Fruits'),
  Product(imageUrl: 'assets/apple.jpg', title: 'Apple', price: '200', category: 'Fruits'),
  Product(imageUrl: 'assets/spinach.jpg', title: 'Spinach', price: '500', category: 'Vegetables'),
  Product(imageUrl: 'assets/tomato.jpg', title: 'Tomatoes', price: '500', category: 'Vegetables'),
  Product(imageUrl: 'assets/potato.jpg', title: 'Potatoes', price: '1500', category: 'Vegetables'),
  Product(imageUrl: 'assets/cabbage.jpg', title: 'Cabbages', price: '600', category: 'Vegetables'),
  Product(imageUrl: 'assets/watermelon.jpg', title: 'Watermelons', price: '200', category: 'Fruits'),
  Product(imageUrl: 'assets/maize.jpg', title: 'Maize', price: '200', category: 'Cereals'),
  Product(imageUrl: 'assets/bean.jpg', title: 'Bean', price: '300', category: 'Cereals'),
  Product(imageUrl: 'assets/oranges.jpg', title: 'Orange', price: '200', category: 'Fruits'),
  Product(imageUrl: 'assets/pineapple.jpg', title: 'Pineapple', price: '300', category: 'Fruits'),
  Product(imageUrl: 'assets/carrot.jpg', title: 'Carrot', price: '300', category: 'Vegetables'),
];

// Provider to manage the product list state
final productListProvider = StateProvider<List<Product>>((ref) => allProducts);

// Provider to filter products by category
final productCategoryProvider = StateProvider<String>((ref) => 'All');

void filterProducts(WidgetRef ref, String category) {
  final allProductsList = allProducts;
  if (category == 'All') {
    ref.read(productListProvider.notifier).state = allProductsList;
  } else {
    ref.read(productListProvider.notifier).state = allProductsList
        .where((product) => product.category == category)
        .toList();
  }
}
