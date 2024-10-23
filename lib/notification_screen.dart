import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Notifications List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  NotificationCard(
                    icon: Icons.message,
                    title: 'New Message from Alice',
                    description: 'You have a new message in your inbox',
                    timeAgo: '2 hours ago',
                    type: NotificationType.message,
                  ),
                  SizedBox(height: 12),
                  NotificationCard(
                    icon: Icons.calendar_today,
                    title: 'Meeting Reminder',
                    description: "Don't forget your meeting at 3 PM",
                    timeAgo: '3 hours ago',
                    type: NotificationType.reminder,
                  ),
                  SizedBox(height: 12),
                  NotificationCard(
                    icon: Icons.info_outline,
                    title: 'System Alert',
                    description: 'Your system will undergo maintenance tonight',
                    timeAgo: '5 hours ago',
                    type: NotificationType.alert,
                  ),
                ],
              ),
            ),

            // Bottom Navigation Bar
            BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: 0,
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

enum NotificationType { message, reminder, alert }

class NotificationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String timeAgo;
  final NotificationType type;

  const NotificationCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.type,
  });

  IconData get _getIcon {
    switch (type) {
      case NotificationType.message:
        return Icons.notifications;
      case NotificationType.reminder:
        return Icons.calendar_today;
      case NotificationType.alert:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getIcon,
                size: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 12),

            // Notification Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}