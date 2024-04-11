import 'package:flutter/material.dart';

class CapsuleListScreen extends StatelessWidget {
  // Example capsules data
  final List<Map<String, dynamic>> _capsules = [
    {
      'title': 'Family Vacation 2023',
      'message': 'Photos and videos from our trip to Hawaii.',
      'unlockDate': '2025-01-01',
    },
    {
      'title': 'Graduation Memories',
      'message': 'Graduation day pictures, videos, and speeches.',
      'unlockDate': '2024-05-15',
    },
  ];

  Widget _buildCapsuleItem(BuildContext context, int index) {
    var capsule = _capsules[index];
    return ListTile(
      title: Text(capsule['title']),
      subtitle: Text('Unlock Date: ${capsule['unlockDate']}'),
      onTap: () {
        // Placeholder for action, e.g., navigating to a detail view.
        print('Tapped on ${capsule['title']}');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Capsule List'),
      ),
      body: ListView.builder(
        itemCount: _capsules.length,
        itemBuilder: _buildCapsuleItem,
      ),
    );
  }
}
