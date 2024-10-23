import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),
              _buildBreadcrumb(),
              _buildProductHeader(),
              _buildDescription(),
              _buildAddToCartSection(),
              _buildSuggestedProducts(),
              _buildCustomerReviews(),
              _buildAuthorSection(),
              _buildBottomNavBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/farmlink_logo.png',
            height: 30,
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreadcrumb() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          const Icon(Icons.home, size: 16),
          const Text(' / Produce / Fresh / Local',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildProductHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/fresh_produce.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fresh\nProduce',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const Text(
                  'Ubuhlinzi',
                  style: TextStyle(color: Colors.grey),
                ),
                Row(
                  children: [
                    ...List.generate(
                      5,
                      (index) => const Icon(Icons.star, size: 16, color: Colors.amber),
                    ),
                    const SizedBox(width: 8),
                    const Text('483', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        'Fresh Produce is a collection of the best locally grown fruits and vegetables brought to your doorstep. We use sustainable and ethical farming practices to ensure the highest quality produce. From juicy strawberries to crisp lettuce, we have everything you need to make your meals delicious and authentic. Explore our wide selection of fresh produce and discover new flavors to add to your recipes. With farmconnect.you can trust that you are getting the freshest and most flavorful produce available.',
        style: TextStyle(height: 1.5),
      ),
    );
  }

  Widget _buildAddToCartSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Add to cart',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Large Box \$35'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Small Box \$20'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Custom Box'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'You might also like these...',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              _buildSuggestedProductCard(
                'The Harvest Experience',
                'Lucas Smith',
                '\$2',
              ),
              const SizedBox(width: 16),
              _buildSuggestedProductCard(
                'The Farm to Table',
                'Sarah Johnson',
                '\$1',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestedProductCard(String title, String author, String price) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(author),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(price),
                    const Icon(Icons.shopping_cart_outlined, size: 16),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerReviews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                'Customer Reviews',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Text(
                '4.8 / 5 Stars',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        _buildRatingBars(),
        _buildReviewItem(
          'Amanda',
          5,
          'FarmLink is a user-friendly e-commerce platform designed to connect farmers with buyers, making Produce purchases easy. The platform features a simple and intuitive interface.',
          '12 April, 2024',
        ),
        _buildReviewItem(
          'Lessie',
          4,
          'I have used many e-commerce platforms for buying produce, but FarmLink stands out from them rest. Its simple and intuitive interface makes it easy to find and buy the products I need.',
          '12 April, 2024',
        ),
      ],
    );
  }

  Widget _buildRatingBars() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: List.generate(
          5,
          (index) => Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            child: LinearProgressIndicator(
              value: 1.0 - (index * 0.2),
              backgroundColor: Colors.grey[200],
              color: Colors.amber,
              minHeight: 8,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewItem(
      String name, int rating, String comment, String date) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/$name.jpg'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            size: 16,
                            color: index < rating ? Colors.amber : Colors.grey[300],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(date, style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(comment),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.thumb_up_outlined),
                onPressed: () {},
                iconSize: 16,
              ),
              IconButton(
                icon: const Icon(Icons.thumb_down_outlined),
                onPressed: () {},
                iconSize: 16,
              ),
              IconButton(
                icon: const Icon(Icons.comment_outlined),
                onPressed: () {},
                iconSize: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About the author',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/author.jpg'),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'JetTies bullEr is an cccaltnled cutnor ana mineruless advocate known for his transformative work in the Telo or oemondl development...',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(icon: const Icon(Icons.home), onPressed: () {}),
          IconButton(icon: const Icon(Icons.restaurant_menu), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person), onPressed: () {}),
        ],
      ),
    );
  }
}