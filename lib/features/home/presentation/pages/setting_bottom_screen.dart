import 'package:flutter/material.dart';

class SettingBottomScreen extends StatelessWidget {
  const SettingBottomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSettingTile(
          icon: Icons.person_outline,
          title: 'Account Settings',
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.lock_outline,
          title: 'Privacy',
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.help_outline,
          title: 'Help & Support',
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.info_outline,
          title: 'About',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}