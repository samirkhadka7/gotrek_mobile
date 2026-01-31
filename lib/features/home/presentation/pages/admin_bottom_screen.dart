import 'package:flutter/material.dart';

class AdminBottomScreen extends StatelessWidget {
  const AdminBottomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.admin_panel_settings, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Admin Panel',
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