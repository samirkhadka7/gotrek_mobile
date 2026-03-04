import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../widgets/profile_menu_item.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Trigger loading current user data when profile page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AuthBloc>().add(GetCurrentUserEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            context.go('/login');
          }
        },
        builder: (context, state) {
          final user = state is AuthAuthenticated ? state.user : null;

          return CustomScrollView(
            slivers: [
              // Profile Header
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                stretch: true,
                backgroundColor: theme.colorScheme.primary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          // Profile Picture
                          Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 48,
                                  backgroundColor: Colors.white.withOpacity(0.2),
                                  backgroundImage: _hasValidProfileImage(user)
                                      ? NetworkImage(user!.profileImageUrl)
                                      : null,
                                  child: !_hasValidProfileImage(user)
                                      ? const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 48,
                                        )
                                      : null,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () => _showImageOptions(context),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surface,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 18,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Name
                          Text(
                            user?.name ?? 'Trekker',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Email
                          Text(
                            user?.email ?? '',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Subscription Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getSubscriptionColor(user?.subscription),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getSubscriptionIcon(user?.subscription),
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  user?.subscription ?? 'Basic',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () => context.push('/profile/edit'),
                    icon: const Icon(Icons.edit_outlined, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () => context.push('/settings'),
                    icon: const Icon(Icons.settings_outlined, color: Colors.white),
                  ),
                ],
              ),

              // Stats Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Info Section
                      _buildProfileInfoSection(theme, user),
                      const SizedBox(height: 24),

                      // Menu Section
                      _buildMenuSection(theme, context),
                      const SizedBox(height: 24),

                      // Danger Zone
                      _buildDangerZone(theme, context),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Check if user has a valid profile image URL
  bool _hasValidProfileImage(UserEntity? user) {
    if (user == null) return false;
    final imageUrl = user.profileImageUrl;
    return imageUrl.isNotEmpty &&
           (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));
  }

  Color _getSubscriptionColor(String? subscription) {
    switch (subscription?.toLowerCase()) {
      case 'premium':
        return Colors.amber[700]!;
      case 'pro':
        return Colors.purple;
      default:
        return Colors.grey[600]!;
    }
  }

  IconData _getSubscriptionIcon(String? subscription) {
    switch (subscription?.toLowerCase()) {
      case 'premium':
        return Icons.workspace_premium;
      case 'pro':
        return Icons.star;
      default:
        return Icons.person;
    }
  }

  Widget _buildProfileInfoSection(ThemeData theme, UserEntity? user) {
    if (user == null) {
      return SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile Information',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(theme, Icons.phone_outlined, 'Phone', user.phone ?? 'Not set'),
          const Divider(height: 24),
          _buildInfoRow(theme, Icons.verified_user_rounded, 'Account Role', _formatRole(user.role)),
          const Divider(height: 24),
          _buildInfoRow(theme, Icons.hiking_rounded, 'Trekker Type', user.hikerType.toUpperCase()),
          const Divider(height: 24),
          _buildInfoRow(theme, Icons.cake_outlined, 'Age Group', user.ageGroup ?? 'Not set'),
          if (user.bio.isNotEmpty) ...[
            const Divider(height: 24),
            _buildInfoRow(theme, Icons.info_outline, 'Bio', user.bio),
          ],
          if (user.emergencyContact != null) ...[
            const Divider(height: 24),
            _buildInfoRow(
              theme,
              Icons.emergency_outlined,
              'Emergency Contact',
              '${user.emergencyContact!.name ?? 'N/A'} - ${user.emergencyContact!.phone ?? 'N/A'}',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(ThemeData theme, IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatRole(String role) {
    if (role.isEmpty) return 'User';
    return role[0].toUpperCase() + role.substring(1).toLowerCase();
  }

  Widget _buildMenuSection(ThemeData theme, BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final isAdmin = authState is AuthAuthenticated && authState.user.role == 'admin';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (isAdmin)
          ProfileMenuItem(
            icon: Icons.admin_panel_settings_rounded,
            title: 'Admin Dashboard',
            subtitle: 'Manage your application',
            color: Theme.of(context).colorScheme.primary,
            onTap: () => context.go('/admin'),
          )
        else
          ProfileMenuItem(
            icon: Icons.explore_rounded,
            title: 'Explore Trails',
            subtitle: 'Browse and discover trails',
            color: Theme.of(context).colorScheme.primary,
            onTap: () => context.go('/explore'),
          ),
        const SizedBox(height: 12),
        ProfileMenuItem(
          icon: Icons.history_rounded,
          title: 'My Trails',
          subtitle: 'View completed & upcoming trails',
          onTap: () => context.push('/my-trails'),
        ),
        const SizedBox(height: 12),
        ProfileMenuItem(
          icon: Icons.groups_rounded,
          title: 'My Groups',
          subtitle: 'Manage your trekking groups',
          onTap: () => context.push('/my-groups'),
        ),
        const SizedBox(height: 12),
        ProfileMenuItem(
          icon: Icons.receipt_long_rounded,
          title: 'Payment History',
          subtitle: 'View your transactions',
          onTap: () => context.push('/payment-history'),
        ),
        const SizedBox(height: 12),
        ProfileMenuItem(
          icon: Icons.workspace_premium_rounded,
          title: 'Upgrade Plan',
          subtitle: 'Get access to premium features',
          color: Colors.amber,
          onTap: () => context.push('/subscription'),
        ),
        const SizedBox(height: 12),
        ProfileMenuItem(
          icon: Icons.lock_outline_rounded,
          title: 'Change Password',
          subtitle: 'Update your password',
          onTap: () => context.push('/profile/change-password'),
        ),
      ],
    );
  }

  Widget _buildDangerZone(ThemeData theme, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Danger Zone',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.error,
          ),
        ),
        const SizedBox(height: 16),
        ProfileMenuItem(
          icon: Icons.logout_rounded,
          title: 'Logout',
          subtitle: 'Sign out of your account',
          color: Colors.orange,
          onTap: () => _showLogoutDialog(context),
        ),
        const SizedBox(height: 12),
        ProfileMenuItem(
          icon: Icons.delete_forever_rounded,
          title: 'Delete Account',
          subtitle: 'Permanently delete your account',
          color: theme.colorScheme.error,
          onTap: () => _showDeleteAccountDialog(context),
        ),
      ],
    );
  }

  void _showImageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement camera
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement gallery picker
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_rounded, color: Colors.red),
              title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement remove photo
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(const LogoutEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Account',
          style: TextStyle(color: theme.colorScheme.error),
        ),
        content: const Text(
          'This action cannot be undone. All your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement account deletion
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
