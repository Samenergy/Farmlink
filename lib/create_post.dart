import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert'; // For Base64 encoding
import 'dart:io';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final List<File> _selectedImages = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  bool _isUploading = false;
  String? _selectedCategory;

  final List<String> _categories = [
    'Vegetables',
    'Fruits',
    'Dairy & Eggs',
    'Meat & Poultry',
    'Fish & Seafood',
    'Grains & Cereals',
    'Baked Goods',
    'Snacks',
    'Beverages',
    'Condiments & Sauces',
    'Canned & Jarred Goods',
    'Frozen Foods',
    'Pantry Staples',
    'Herbs & Spices',
    'Nuts & Seeds',
    'Desserts & Sweets',
    'Ready Meals',
    'Health Foods',
    'International Foods',
    'Baby Food',
    'Pet Food'
  ];

  Future<void> _pickMultipleImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    setState(() {
      _selectedImages.clear();
      _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
    });
  }

  Future<List<String>> _convertImagesToBase64() async {
    List<String> base64Images = [];
    for (var imageFile in _selectedImages) {
      try {
        List<int> imageBytes = await imageFile.readAsBytes();
        String base64String = base64Encode(imageBytes);
        base64Images.add(base64String);
      } catch (e) {
        throw Exception('Error converting image to Base64: $e');
      }
    }
    return base64Images;
  }

  Future<void> _postProduct() async {
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select at least one image!'),
      ));
      return;
    }

    if (_productNameController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _detailsController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill all fields!'),
      ));
      return;
    }

    try {
      User? user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User is not logged in!'),
        ));
        return;
      }

      setState(() {
        _isUploading = true;
      });

      List<String> base64Images = await _convertImagesToBase64();

      await FirebaseFirestore.instance.collection('posts').add({
        'product_name': _productNameController.text,
        'category': _selectedCategory,
        'quantity': int.parse(_quantityController.text),
        'details': _detailsController.text,
        'price': int.parse(_priceController.text),
        'images': base64Images,
        'user_id': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'OnSale', // Set default status to "OnSale"
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Product posted successfully!'),
      ));

      setState(() {
        _isUploading = false;
        _selectedImages.clear();
        _productNameController.clear();
        _quantityController.clear();
        _detailsController.clear();
        _priceController.clear();
        _selectedCategory = null;
      });
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error posting product: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 252, 252, 252),
        title: const Text(
          'Create a Post',
          style: TextStyle(color: Color(0xFF000000)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter Images',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    _buildImageGrid(),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _pickMultipleImages,
                      icon: const Icon(
                        Icons.image,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Select Images',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'The first image is the title image.\n'
                      'Drag and reorder as desired.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF100A0A)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              _buildDropdown(),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _productNameController,
                hintText: 'Product name',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _quantityController,
                hintText: 'Quantity Available in Kg',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _detailsController,
                hintText: 'Product details',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _priceController,
                hintText: 'Price of 1Kg in Rwf',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: _isUploading ? null : _postProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF000000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 60.0,
                    ),
                    child: _isUploading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Post',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      hint: const Text('Select Category'),
      items: _categories.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value;
        });
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildImageGrid() {
    if (_selectedImages.isEmpty) {
      return const Text('No images selected.');
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _selectedImages.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Image.file(
              _selectedImages[index],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              top: 5,
              right: 5,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedImages.removeAt(index);
                  });
                },
                child: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
