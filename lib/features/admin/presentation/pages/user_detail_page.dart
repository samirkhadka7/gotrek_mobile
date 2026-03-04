import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/admin_user_bloc.dart';
import '../bloc/admin_user_event.dart';
import '../bloc/admin_user_state.dart';

/// Detailed view and edit page for a user
class UserDetailPage extends StatefulWidget {
  final String userId;

  const UserDetailPage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  String _selectedRole = 'user';

  @override
  void initState() {
    super.initState();
    // Load user details could go here if implemented
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: BlocListener<AdminUserBloc, AdminUserState>(
        listener: (context, state) {
          if (state is UserRoleUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Role updated successfully')),
            );
            Navigator.pop(context);
          } else if (state is AdminUserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: BlocBuilder<AdminUserBloc, AdminUserState>(
          builder: (context, state) {
            if (state is AdminUserLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Display placeholder - in real app, load full user details
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User ID: ${widget.userId}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Change User Role',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    value: _selectedRole,
                    items: const [
                      DropdownMenuItem(value: 'user', child: Text('User')),
                      DropdownMenuItem(value: 'guide', child: Text('Guide')),
                      DropdownMenuItem(value: 'admin', child: Text('Admin')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value ?? 'user';
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<AdminUserBloc>().add(
                          UpdateUserRoleEvent(
                            userId: widget.userId,
                            newRole: _selectedRole,
                          ),
                        );
                      },
                      child: const Text('Update Role'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete User'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Delete User?'),
                            content: const Text(
                              'Are you sure you want to delete this user? This action cannot be undone.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.read<AdminUserBloc>().add(
                                    DeleteUserEvent(widget.userId),
                                  );
                                  Navigator.pop(context);
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
