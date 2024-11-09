import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final List<File> _selectedImages = []; // List to store selected images

  // Function to select multiple images from the gallery
  Future<void> _pickMultipleImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(); // Select multiple images

    setState(() {
      _selectedImages.clear(); // Clear previous selection
      _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
    });
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
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Back icon
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
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

              // Image Upload Section
              Center(
                child: Column(
                  children: [
                    _buildImageGrid(), // Display selected images
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _pickMultipleImages,
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
                      'Grab and draw the image to change the order.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF100A0A)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Text Fields
              const CustomTextField(hintText: 'Product name'),
              const SizedBox(height: 16),
              const CustomTextField(hintText: 'Quantity Available'),
              const SizedBox(height: 16),
              const CustomTextField(hintText: 'Product details'),
              const SizedBox(height: 16),
              const CustomTextField(hintText: 'Price'),
              const SizedBox(height: 40),

              // Post Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Posting the Product
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF000000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 14.0, horizontal: 60.0),
                    child: Text(
                      'Post',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
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

  // Widget to display selected images in a grid
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
                    _selectedImages.removeAt(index); // Remove image
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

// Custom Text Field Widget
class CustomTextField extends StatelessWidget {
  final String hintText;

  const CustomTextField({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
