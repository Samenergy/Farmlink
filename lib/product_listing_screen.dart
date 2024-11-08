import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
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

  void removeProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  void editProduct(int index) {
    final product = products[index];
    final TextEditingController nameController =
        TextEditingController(text: product['name']);
    final TextEditingController priceController =
        TextEditingController(text: product['price'].toString());
    final TextEditingController quantityController =
        TextEditingController(text: product['quantity'].toString());
    final TextEditingController descriptionController =
        TextEditingController(text: product['description']); // Added

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Product Price'),
                ),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Product Quantity (Kg)'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration:
                      const InputDecoration(labelText: 'Product Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  products[index]['name'] = nameController.text;
                  products[index]['price'] = double.parse(priceController.text);
                  products[index]['quantity'] =
                      double.parse(quantityController.text);
                  products[index]['description'] = descriptionController.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Listing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: products.isEmpty
            ? const Center(child: Text('No products available.'))
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        product['imageUrl'] ?? 'assets/default_image.jpg',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product['name'] ?? 'Unknown Product'),
                          Text(
                            'Price: \$${product['price']?.toStringAsFixed(2) ?? 'N/A'}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Quantity: ${product['quantity']?.toString() ?? '0'} Kg',
                          ),
                          Text(
                            product['description'] ?? 'No description available',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.black),
                                onPressed: () => editProduct(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.black),
                                onPressed: () => removeProduct(index),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UploadProductScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({super.key});

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  XFile? _image;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  void uploadProduct() {
    if (nameController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        quantityController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        _image != null) {
      // Upload logic or API call can be placed here
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select an image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _image == null
                      ? const Center(child: Text('Tap to select an image'))
                      : Image.file(
                          File(_image!.path),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity (Kg)'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: uploadProduct,
                child: const Text('Upload Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
