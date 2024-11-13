import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:typed_data';

class Product {
  final String imageUrl;
  final String name;
  final int price;
  final String category;
  final int quantity;
  final String status;
  final DateTime timestamp;
  final String details;
  final String userId;

  Product({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.category,
    required this.quantity,
    required this.status,
    required this.timestamp,
    required this.details,
    required this.userId,
  });

  // Factory method to create Product from Firestore document
  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      imageUrl:
          data['images']?[0] ?? '', // Fetching the first image if it's an array
      name: data['product_name'] ??
          '', // Adjusted to match the key in your Firestore
      price: data['price'] ?? 0,
      category: data['category'] ?? '',
      quantity: data['quantity'] ?? 0,
      status: data['status'] ?? '',
      timestamp: (data['timestamp'] as Timestamp)
          .toDate(), // Converting Firestore Timestamp to DateTime
      details: data['details'] ?? '',
      userId: data['user_id'] ?? '',
    );
  }

  // Method to decode the base64 image string
  ImageProvider get decodedImage {
    final decodedBytes = base64Decode(imageUrl);
    return MemoryImage(decodedBytes);
  }

  get description => null;

  get image => null;
}

// Correct provider to fetch the product list from Firestore using StreamProvider
final productListProvider = StreamProvider<List<Product>>((ref) {
  return FirebaseFirestore.instance.collection('posts').snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList());
});
