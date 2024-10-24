import 'package:flutter/material.dart';
import 'order_accepted_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int watermelonQty = 1;
  int cabbageQty = 1;

  int getTotalCost() {
    return (watermelonQty * 500) + (cabbageQty * 200);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Back navigation
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Handle cart action
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildCartItem('Watermelon', '1kg', 500, watermelonQty,
                          (value) {
                        setState(() {
                          watermelonQty = value;
                        });
                      }),
                      const SizedBox(height: 16),
                      _buildCartItem('Cabbages', '1kg', 200, cabbageQty,
                          (value) {
                        setState(() {
                          cabbageQty = value;
                        });
                      }),
                      const Spacer(),
                      _buildCheckoutSummary(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const OrderAcceptedScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(
                  double.infinity, 60), // Full width and increased height
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Larger border radius
              ),
              alignment: Alignment.center, // Ensures the text stays centered
            ),
            child: const Text(
              'Place Order',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16, // Increased font size
                fontWeight: FontWeight.bold, // Bold text
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartItem(String title, String weight, int price, int qty,
      Function(int) onQtyChanged) {
    return Row(
      children: [
        Image.network(
          'https://via.placeholder.com/150',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(weight),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            IconButton(
              onPressed: () {
                if (qty > 1) onQtyChanged(qty - 1);
              },
              icon: const Icon(Icons.remove),
            ),
            Text('$qty'),
            IconButton(
              onPressed: () {
                onQtyChanged(qty + 1);
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        Text('${price * qty} Rwf'),
      ],
    );
  }

  Widget _buildCheckoutSummary() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: const Text('Delivery'),
            trailing: const Text('Select Method'),
            onTap: () {
              // Handle delivery method selection
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Payment'),
            trailing: const Icon(Icons.payment, color: Colors.blue),
            onTap: () {
              // Handle payment method selection
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Promo Code'),
            trailing: const Text('Pick discount'),
            onTap: () {
              // Handle promo code selection
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Total Cost'),
            trailing: Text(
              '${getTotalCost()} Rwf',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'By placing an order you agree to our Terms and Conditions',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
