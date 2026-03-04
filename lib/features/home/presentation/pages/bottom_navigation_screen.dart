import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/pages/login_page.dart';
import 'home_bottom_screen.dart';
import 'group_bottom_screen.dart';
import 'profile_bottom_screen.dart';
import 'setting_bottom_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _selectedIndex = 0;

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.logout_rounded,
                color: Colors.red.shade600,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Sign Out',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: Theme.of(ctx).colorScheme.onSurfaceVariant, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                  color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthBloc>().add(const LogoutEvent());
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'Sign Out',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        const List<Widget> screens = [
          HomeBottomScreen(),
          GroupBottomScreen(),
          ProfileBottomScreen(),
          SettingBottomScreen(),
        ];

        const List<String> titles = [
          'GoTrek',
          'Groups',
          'Profile',
          'Settings',
        ];

        if (_selectedIndex >= screens.length) _selectedIndex = 0;

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: AppBar(
            backgroundColor: theme.colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0.5,
            titleSpacing: 16,
            title: Row(
              children: [
                // Logo
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/main.jpg',
                      width: 34,
                      height: 34,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 34,
                        height: 34,
                        color: theme.colorScheme.primary,
                        child: const Icon(Icons.terrain_rounded,
                            size: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  titles[_selectedIndex],
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.logout_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 22,
                ),
                tooltip: 'Sign Out',
                onPressed: _showLogoutDialog,
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: screens[_selectedIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) =>
                setState(() => _selectedIndex = index),
            backgroundColor: theme.colorScheme.surface,
            indicatorColor: theme.colorScheme.primaryContainer,
            height: 72,
            animationDuration: const Duration(milliseconds: 350),
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              const NavigationDestination(
                icon: Icon(Icons.group_outlined),
                selectedIcon: Icon(Icons.group_rounded),
                label: 'Groups',
              ),
              const NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
              const NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings_rounded),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
