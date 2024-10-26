import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final List<Map<String, dynamic>> feedbacks = [
    {
      'name': 'John Doe',
      'rating': 5,
      'comment': 'Excellent product!',
      'date': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'name': 'Jane Smith',
      'rating': 4,
      'comment': 'Good quality, fast delivery.',
      'date': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'name': 'Mike Johnson',
      'rating': 3,
      'comment': 'Okay, but could be cheaper.',
      // Intentionally left `date` as null to test fallback
      'date': null,
    },
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  int _rating = 3;
  bool _isSubmitting = false;

  @override
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final availableHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.viewInsets.bottom; // Adjust height based on keyboard

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: availableHeight, // Set height to available height
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildFeedbackList()),
                const SizedBox(height: 16),
                _buildFeedbackForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackList() {
    return AnimatedList(
      key: _listKey,
      initialItemCount: feedbacks.length,
      itemBuilder: (context, index, animation) {
        return _buildFeedbackTile(feedbacks[index], animation);
      },
    );
  }

  Widget _buildFeedbackTile(
      Map<String, dynamic> feedback, Animation<double> animation) {
    final DateTime date =
        feedback['date'] ?? DateTime.now(); // Fallback to current date

    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOut)),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.orange,
            child: Text(feedback['rating'].toString()),
          ),
          title: Text(feedback['name'],
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(feedback['comment']),
              const SizedBox(height: 4),
              Text(
                DateFormat('MMM d, yyyy, h:mm a')
                    .format(date), // Format the date safely
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          trailing: const Icon(Icons.feedback, color: Colors.orange),
        ),
      ),
    );
  }

  Widget _buildFeedbackForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Leave a Feedback',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            hintText: 'Enter your name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _commentController,
          maxLines: 2,
          decoration: const InputDecoration(
            hintText: 'Enter your comment',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        _buildRatingSelector(),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSubmitting
                ? null
                : _submitFeedback, // Disable button while submitting
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E1E1E),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isSubmitting
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'Submit Feedback',
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSelector() {
    return Row(
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: Colors.orange,
          ),
          onPressed: () {
            setState(() {
              _rating = index + 1;
            });
          },
        );
      }),
    );
  }

  void _submitFeedback() async {
    final String name = _nameController.text.trim();
    final String comment = _commentController.text.trim();

    if (name.isEmpty || comment.isEmpty) {
      _showSnackBar('Please fill in all fields.', Colors.red);
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    final newFeedback = {
      'name': name,
      'rating': _rating,
      'comment': comment,
      'date': DateTime.now(),
    };

    setState(() {
      feedbacks.insert(0, newFeedback); // Add new feedback to the top
      _listKey.currentState?.insertItem(0); // Animate addition
      _isSubmitting = false;
    });

    _nameController.clear();
    _commentController.clear();
    _rating = 3; // Reset rating

    _showSnackBar('Thank you for your feedback!', Colors.green);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration:
            Duration(seconds: (message.length / 10).ceil()), // Adjust duration
      ),
    );
  }
}
