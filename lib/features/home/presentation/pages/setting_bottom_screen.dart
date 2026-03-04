import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../settings/presentation/bloc/theme_bloc.dart';
import '../../../settings/presentation/bloc/theme_event.dart';
import '../../../settings/presentation/bloc/theme_state.dart';

class SettingBottomScreen extends StatelessWidget {
  const SettingBottomScreen({super.key});

  void _showAppearanceSheet(BuildContext context, ThemeState currentState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _AppearanceSheet(
        currentState: currentState,
        themeBloc: context.read<ThemeBloc>(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user =
            state is AuthAuthenticated ? state.user : null;

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── User mini-card ─────────────────────────────────────────
              if (user != null) ...[
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color:
                            theme.colorScheme.primary.withValues(alpha: 0.28),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor:
                            Colors.white.withValues(alpha: 0.25),
                        backgroundImage: user.profileImageUrl.isNotEmpty
                            ? NetworkImage(user.profileImageUrl)
                            : null,
                        child: user.profileImageUrl.isEmpty
                            ? const Icon(Icons.person_rounded,
                                size: 30, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name.isNotEmpty
                                  ? user.name
                                  : user.email.split('@').first,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              user.email,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.75),
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.30),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          user.role.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
              ] else
                const SizedBox(height: 16),

              // ── Account section ────────────────────────────────────────
              _SectionHeader(title: 'Account', theme: theme),
              const SizedBox(height: 8),
              _SettingGroup(children: [
                _SettingTile(
                  icon: Icons.person_outline_rounded,
                  iconBgColor: const Color(0xFF1565C0),
                  title: 'Edit Profile',
                  subtitle: 'Update your name, photo and bio',
                  onTap: () {},
                  theme: theme,
                ),
                _SettingTile(
                  icon: Icons.lock_outline_rounded,
                  iconBgColor: const Color(0xFF2E7D32),
                  title: 'Change Password',
                  subtitle: 'Secure your account',
                  onTap: () => context.push('/change-password'),
                  theme: theme,
                ),
                _SettingTile(
                  icon: Icons.notifications_outlined,
                  iconBgColor: const Color(0xFFE65100),
                  title: 'Notifications',
                  subtitle: 'Manage push notifications',
                  showDivider: false,
                  onTap: () {},
                  theme: theme,
                ),
              ]),

              const SizedBox(height: 24),

              // ── Preferences section ────────────────────────────────────
              _SectionHeader(title: 'Preferences', theme: theme),
              const SizedBox(height: 8),
              _SettingGroup(children: [
                BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (ctx, themeState) {
                    final subtitle = switch (themeState) {
                      LightThemeState() => 'Light mode',
                      DarkThemeState() => 'Dark mode',
                      AutoThemeState() => 'Auto • Time-based',
                      SystemThemeState() => 'System default',
                      _ => 'Light / Dark / Auto',
                    };
                    return _SettingTile(
                      icon: Icons.dark_mode_outlined,
                      iconBgColor: const Color(0xFF4A148C),
                      title: 'Appearance',
                      subtitle: subtitle,
                      onTap: () => _showAppearanceSheet(ctx, themeState),
                      theme: theme,
                    );
                  },
                ),
                _SettingTile(
                  icon: Icons.language_rounded,
                  iconBgColor: const Color(0xFF00695C),
                  title: 'Language',
                  subtitle: 'English',
                  showDivider: false,
                  onTap: () {},
                  theme: theme,
                ),
              ]),

              const SizedBox(height: 24),

              // ── Support section ────────────────────────────────────────
              _SectionHeader(title: 'Support', theme: theme),
              const SizedBox(height: 8),
              _SettingGroup(children: [
                _SettingTile(
                  icon: Icons.help_outline_rounded,
                  iconBgColor: const Color(0xFF0277BD),
                  title: 'Help & Support',
                  subtitle: 'FAQs and contact us',
                  onTap: () {},
                  theme: theme,
                ),
                _SettingTile(
                  icon: Icons.privacy_tip_outlined,
                  iconBgColor: const Color(0xFF4E342E),
                  title: 'Privacy Policy',
                  onTap: () {},
                  theme: theme,
                ),
                _SettingTile(
                  icon: Icons.description_outlined,
                  iconBgColor: const Color(0xFF37474F),
                  title: 'Terms of Service',
                  onTap: () {},
                  theme: theme,
                ),
                _SettingTile(
                  icon: Icons.info_outline_rounded,
                  iconBgColor: const Color(0xFF558B2F),
                  title: 'About GoTrek',
                  subtitle: 'Version 1.0.0',
                  showDivider: false,
                  onTap: () {},
                  theme: theme,
                ),
              ]),

              // ── Admin section (only for admins) ───────────────────────
              if (user != null && user.role == 'admin') ...[
                const SizedBox(height: 24),
                _SectionHeader(title: 'Administration', theme: theme),
                const SizedBox(height: 8),
                _SettingGroup(children: [
                  _SettingTile(
                    icon: Icons.admin_panel_settings_rounded,
                    iconBgColor: const Color(0xFFB71C1C),
                    title: 'Admin Panel',
                    subtitle: 'Manage users, trails & content',
                    showDivider: false,
                    onTap: () => context.push(AppRoutes.admin),
                    theme: theme,
                  ),
                ]),
              ],

              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final ThemeData theme;
  const _SectionHeader({required this.title, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurfaceVariant,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingGroup extends StatelessWidget {
  final List<Widget> children;
  const _SettingGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.07),
        ),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool showDivider;
  final ThemeData theme;

  const _SettingTile({
    required this.icon,
    required this.iconBgColor,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.showDivider = true,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Icon container
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 14),

                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 70,
            endIndent: 16,
            color: theme.colorScheme.outline.withValues(alpha: 0.08),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Appearance bottom sheet
// ─────────────────────────────────────────────────────────────────────────────

class _AppearanceSheet extends StatelessWidget {
  final ThemeState currentState;
  final ThemeBloc themeBloc;

  const _AppearanceSheet({
    required this.currentState,
    required this.themeBloc,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    void select(ThemeEvent event) {
      themeBloc.add(event);
      Navigator.pop(context);
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Appearance',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Choose how GoTrek looks on your device',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _ThemeOptionTile(
            icon: Icons.light_mode_rounded,
            iconColor: const Color(0xFFF57F17),
            title: 'Light',
            subtitle: 'Always use light theme',
            isSelected: currentState is LightThemeState,
            onTap: () => select(const SetLightThemeEvent()),
            theme: theme,
          ),
          _ThemeOptionTile(
            icon: Icons.dark_mode_rounded,
            iconColor: const Color(0xFF311B92),
            title: 'Dark',
            subtitle: 'Always use dark theme',
            isSelected: currentState is DarkThemeState,
            onTap: () => select(const SetDarkThemeEvent()),
            theme: theme,
          ),
          _ThemeOptionTile(
            icon: Icons.sensors_rounded,
            iconColor: const Color(0xFF00695C),
            title: 'Auto',
            subtitle: 'Uses ambient light sensor • Dark in dim light',
            isSelected: currentState is AutoThemeState,
            onTap: () => select(const SetAutoThemeEvent()),
            theme: theme,
          ),
          _ThemeOptionTile(
            icon: Icons.phone_android_rounded,
            iconColor: const Color(0xFF37474F),
            title: 'System Default',
            subtitle: 'Follows your device settings',
            isSelected: currentState is SystemThemeState,
            onTap: () => select(const SetSystemThemeEvent()),
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;

  const _ThemeOptionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer.withValues(alpha: 0.5)
              : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.12),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: theme.colorScheme.primary,
                size: 22,
              )
            else
              Icon(
                Icons.radio_button_unchecked_rounded,
                color: theme.colorScheme.outline.withValues(alpha: 0.4),
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
