import 'package:flutter/material.dart';

class GroupBottomScreen extends StatelessWidget {
  const GroupBottomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Groups',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Coming Soon!',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}