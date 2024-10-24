import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            // Profile Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/profile.png'),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jane Ingabire',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '@ingjames23',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Edit'),
                  ),
                ],
              ),
            ),

            // Menu Items
            const MenuListTile(
              icon: Icons.shopping_bag_outlined,
              title: 'Orders',
            ),
            const MenuListTile(
              icon: Icons.inventory_2_outlined,
              title: 'My Products',
            ),
            const MenuListTile(
              icon: Icons.location_on_outlined,
              title: 'Delivery Address',
            ),
            const MenuListTile(
              icon: Icons.payment_outlined,
              title: 'Payment Methods',
            ),
            const MenuListTile(
              icon: Icons.local_offer_outlined,
              title: 'Promo Code',
            ),
            const MenuListTile(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
            ),
            const MenuListTile(
              icon: Icons.help_outline,
              title: 'Help',
            ),
            const MenuListTile(
              icon: Icons.settings_outlined,
              title: 'Settings',
            ),

            // Log Out Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text(
                      'Log Out',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Bottom Navigation Bar
            BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: 3, // Profile tab
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_outlined),
                  label: 'Cart',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'Profile',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MenuListTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const MenuListTile({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.black54,
      ),
      onTap: () {},
    );
  }
}
