import 'package:flutter/material.dart';
import '../../domain/entities/admin_user_entity.dart';

/// Widget displaying a user in the admin list
class UserListItemWidget extends StatelessWidget {
  final AdminUserEntity user;
  final VoidCallback onTap;

  const UserListItemWidget({
    Key? key,
    required this.user,
    required this.onTap,
  }) : super(key: key);

  Color _getRoleColor() {
    switch (user.role) {
      case 'admin':
        return Colors.red;
      case 'guide':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getRoleLabel() {
    return user.role.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = user.profileImageUrl;
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: imageUrl.isNotEmpty
            ? NetworkImage(imageUrl)
            : null,
        child: imageUrl.isEmpty
            ? Text(user.name[0].toUpperCase())
            : null,
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: Chip(
        label: Text(_getRoleLabel()),
        backgroundColor: _getRoleColor().withOpacity(0.2),
        labelStyle: TextStyle(
          color: _getRoleColor(),
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }
}
