import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final List<File> _selectedImages = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  bool _isUploading = false;

  // Pick multiple images from the gallery
  Future<void> _pickMultipleImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    setState(() {
      _selectedImages.clear();
      if (pickedFiles != null) {
        _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
      }
    });
  }

  // Upload images to Firebase Storage and get URLs
  Future<List<String>> _uploadImages() async {
    List<String> imageUrls = [];
    for (var imageFile in _selectedImages) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      try {
        UploadTask uploadTask =
            _storage.ref().child('posts/$fileName.jpg').putFile(imageFile);

        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      } catch (e) {
        throw Exception('Error uploading image: $e');
      }
    }
    return imageUrls;
  }

  // Post the product to Firestore
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
        _priceController.text.isEmpty) {
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

      List<String> imageUrls = await _uploadImages();

      await FirebaseFirestore.instance.collection('posts').add({
        'product_name': _productNameController.text,
        'quantity': _quantityController.text,
        'details': _detailsController.text,
        'price': _priceController.text,
        'images': imageUrls,
        'user_id': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
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
                      icon: const Icon(Icons.image),
                      label: const Text('Select Images'),
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
              _buildTextField(
                controller: _productNameController,
                hintText: 'Product name',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _quantityController,
                hintText: 'Quantity Available',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _detailsController,
                hintText: 'Product details',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _priceController,
                hintText: 'Price',
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
