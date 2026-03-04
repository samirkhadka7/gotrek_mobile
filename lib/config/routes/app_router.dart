import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_main.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/payment/presentation/bloc/payment_bloc.dart';
import '../../features/messaging/presentation/bloc/message_bloc.dart';
import '../../features/messaging/presentation/pages/chat_room_page.dart';
import '../../features/messaging/presentation/pages/group_chats_list_page.dart';
import '../../features/chatbot/presentation/pages/chatbot_page.dart';
import '../../injection/injection.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/checklist/presentation/pages/checklist_page.dart';
import '../../features/trail/presentation/pages/trails_page.dart';
import '../../features/trail/presentation/pages/trail_details_page.dart';
import '../../features/group/presentation/pages/groups_page.dart';
import '../../features/group/presentation/bloc/group_bloc.dart';
import '../../features/group/presentation/pages/group_details_page.dart';
import '../../features/group/presentation/pages/create_group_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/payment/presentation/pages/subscription_page.dart';
import '../../features/payment/presentation/pages/payment_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/auth/presentation/pages/change_password_page.dart';
import '../../features/achievements/presentation/pages/achievements_page.dart';
import '../../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../../features/admin/presentation/bloc/admin_user_bloc.dart';
import '../../features/admin/presentation/bloc/admin_trail_bloc.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/steps/presentation/bloc/steps_bloc.dart';
import '../../features/steps/presentation/pages/steps_page.dart';
import '../../features/profile/presentation/pages/my_trails_page.dart';
import '../../features/profile/presentation/pages/my_groups_page.dart';
import '../../features/profile/presentation/pages/payment_history_page.dart';
import 'app_routes.dart';

/// App Router configuration using go_router
class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  /// Create and return the GoRouter instance
  static GoRouter createRouter(AuthBloc authBloc, {bool skipSplash = false}) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: skipSplash ? AppRoutes.home : AppRoutes.splash,
      debugLogDiagnostics: true,
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        final authState = authBloc.state;
        final isAuthenticated = authState is AuthAuthenticated;
        final location = state.matchedLocation;
        final isSplash = location == AppRoutes.splash;
        final isOnboarding = location == AppRoutes.onboarding;
        final isAuthRoute = location == AppRoutes.login ||
            location == AppRoutes.signup ||
            location == AppRoutes.forgotPassword ||
            location == AppRoutes.resetPassword;

        // Let SplashScreen handle its own navigation after the timer
        if (isSplash) return null;

        // Onboarding is accessible without auth
        if (isOnboarding) return null;

        // Don't redirect while auth status is still being determined
        if (authState is AuthInitial || authState is AuthLoading) {
          return null;
        }

        // If authenticated and trying to access auth routes, redirect to home
        if (isAuthenticated && isAuthRoute) {
          return AppRoutes.home;
        }

        // If not authenticated and trying to access protected routes
        if (!isAuthenticated && !isAuthRoute) {
          return AppRoutes.login;
        }

        return null;
      },
      routes: [
        // Splash Route
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashScreen(),
        ),

        // Onboarding Route
        GoRoute(
          path: AppRoutes.onboarding,
          builder: (context, state) => const OnboardingMain(),
        ),

        // Auth Routes
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => BlocProvider.value(
            value: authBloc,
            child: const LoginPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.signup,
          builder: (context, state) => BlocProvider.value(
            value: authBloc,
            child: const SignUpPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.forgotPassword,
          builder: (context, state) => BlocProvider.value(
            value: authBloc,
            child: const ForgotPasswordPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.resetPassword,
          builder: (context, state) {
            final email = state.extra as String?;
            return BlocProvider.value(
              value: authBloc,
              child: ResetPasswordPage(email: email),
            );
          },
        ),

        // Main Shell Route (with bottom navigation)
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return MainShell(child: child);
          },
          routes: [
            // Home/Dashboard Route
            GoRoute(
              path: AppRoutes.home,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const DashboardScreen(),
              ),
            ),

            // Explore Route
            GoRoute(
              path: AppRoutes.explore,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const ExploreScreen(),
              ),
            ),

            // Groups Route
            GoRoute(
              path: AppRoutes.groups,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const GroupsScreen(),
              ),
            ),

            // Admin Route (only accessible by admins)
            GoRoute(
              path: AppRoutes.admin,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const AdminScreen(),
              ),
            ),

            // Chat Route - Shows group chats list
            GoRoute(
              path: AppRoutes.chat,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const GroupChatsScreen(),
              ),
            ),

            // Profile Route
            GoRoute(
              path: AppRoutes.profile,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const ProfileScreen(),
              ),
            ),
          ],
        ),

        // Trail Details Route
        GoRoute(
          path: AppRoutes.trailDetails,
          builder: (context, state) {
            final trailId = state.pathParameters['id']!;
            return TrailDetailsPage(trailId: trailId);
          },
        ),

        // Group Routes
        GoRoute(
          path: AppRoutes.groupDetails,
          builder: (context, state) {
            final groupId = state.pathParameters['id']!;
            return GroupDetailsPage(groupId: groupId);
          },
        ),
        GoRoute(
          path: AppRoutes.createGroup,
          builder: (context, state) => const CreateGroupPage(),
        ),

        // Chat Room Route
        GoRoute(
          path: AppRoutes.chatRoom,
          builder: (context, state) {
            final groupId = state.pathParameters['groupId']!;
            final groupName = state.extra as String? ?? 'Chat';
            return BlocProvider(
              create: (context) => sl<MessageBloc>(),
              child: ChatRoomPage(
                groupId: groupId,
                groupName: groupName,
              ),
            );
          },
        ),

        // Profile Routes
        GoRoute(
          path: AppRoutes.editProfile,
          builder: (context, state) => const EditProfilePage(),
        ),
        GoRoute(
          path: AppRoutes.changePassword,
          builder: (context, state) => const ChangePasswordPage(),
        ),
        GoRoute(
          path: AppRoutes.achievements,
          builder: (context, state) => const AchievementsPage(),
        ),

        // Subscription & Payment Routes
        GoRoute(
          path: AppRoutes.subscription,
          builder: (context, state) => BlocProvider(
            create: (context) => sl<PaymentBloc>(),
            child: const SubscriptionPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.payment,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final plan = extra['plan'] as String? ?? 'Pro';
            final amount = (extra['amount'] as num?)?.toDouble() ?? 299.0;
            final planName = extra['planName'] as String? ?? plan;
            return BlocProvider(
              create: (context) => sl<PaymentBloc>(),
              child: PaymentPage(
                plan: plan,
                amount: amount,
                planName: planName,
              ),
            );
          },
        ),

        // Checklist Routes
        GoRoute(
          path: AppRoutes.checklist,
          builder: (context, state) => const ChecklistPage(),
        ),

        // Chatbot Route
        GoRoute(
          path: AppRoutes.chatbot,
          builder: (context, state) => const ChatbotScreen(),
        ),

        // Notifications Route
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: AppRoutes.notifications,
          builder: (context, state) => const NotificationsPage(),
        ),

        // My Trails Route
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: AppRoutes.myTrails,
          builder: (context, state) => const MyTrailsPage(),
        ),

        // My Groups Route
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: AppRoutes.myGroups,
          builder: (context, state) => const MyGroupsPage(),
        ),

        // Payment History Route
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: AppRoutes.paymentHistory,
          builder: (context, state) => const PaymentHistoryPage(),
        ),

        // Steps Route
        GoRoute(
          path: AppRoutes.steps,
          builder: (context, state) => BlocProvider(
            create: (context) => sl<StepsBloc>()
              ..add(const LoadTodayStepsEvent())
              ..add(const LoadWeeklyStatsEvent()),
            child: const StepsPage(),
          ),
        ),

        // Settings Route
        GoRoute(
          path: AppRoutes.settings,
          builder: (context, state) => const SettingsPage(),
        ),
      ],
      errorBuilder: (context, state) => ErrorScreen(error: state.error),
    );
  }
}

/// Stream wrapper for GoRouter refresh - only notifies on auth status changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<AuthState> stream) {
    AuthState? lastState;

    _subscription = stream.asBroadcastStream().listen((state) {
      final isAuthenticated = state is AuthAuthenticated;
      final wasAuthenticated = lastState is AuthAuthenticated;
      final becameUnauthenticated =
          state is AuthUnauthenticated && lastState is! AuthUnauthenticated;

      // Notify on auth status changes or when unauthenticated becomes known
      if (isAuthenticated != wasAuthenticated || becameUnauthenticated) {
        notifyListeners();
      }

      lastState = state;
    });
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

// ==================== Shell & Screens ====================

class MainShell extends StatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Determine current index based on current route location
        int currentIndex = 0;
        final location = GoRouterState.of(context).uri.path;

        bool isRouteOrSubroute(String route) {
          return location == route || location.startsWith('$route/');
        }

        if (isRouteOrSubroute(AppRoutes.profile)) {
          currentIndex = 4;
        } else if (isRouteOrSubroute(AppRoutes.chat)) {
          currentIndex = 3;
        } else if (isRouteOrSubroute(AppRoutes.groups)) {
          currentIndex = 2;
        } else if (isRouteOrSubroute(AppRoutes.explore)) {
          currentIndex = 1;
        } else if (isRouteOrSubroute(AppRoutes.home)) {
          currentIndex = 0;
        }

        return Scaffold(
          body: widget.child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              switch (index) {
                case 0:
                  context.go(AppRoutes.home);
                  break;
                case 1:
                  context.go(AppRoutes.explore);
                  break;
                case 2:
                  context.go(AppRoutes.groups);
                  break;
                case 3:
                  context.go(AppRoutes.chat);
                  break;
                case 4:
                  context.go(AppRoutes.profile);
                  break;
              }
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.explore_outlined),
                selectedIcon: Icon(Icons.explore),
                label: 'Explore',
              ),
              NavigationDestination(
                icon: Icon(Icons.group_outlined),
                selectedIcon: Icon(Icons.group),
                label: 'Groups',
              ),
              NavigationDestination(
                icon: Icon(Icons.chat_outlined),
                selectedIcon: Icon(Icons.chat),
                label: 'Chat',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}

// Screen wrappers using actual feature implementations

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TrailsPage();
  }
}

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GroupsPage();
  }
}

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AdminUserBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<AdminTrailBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<GroupBloc>(),
        ),
      ],
      child: const AdminDashboardPage(),
    );
  }
}

class GroupChatsScreen extends StatelessWidget {
  const GroupChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<MessageBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<GroupBloc>(),
        ),
      ],
      child: const GroupChatsListPage(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfilePage();
  }
}

class TrailDetailsScreen extends StatelessWidget {
  final String trailId;

  const TrailDetailsScreen({super.key, required this.trailId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trail Details')),
      body: Center(child: Text('Trail ID: $trailId')),
    );
  }
}

class GroupDetailsScreen extends StatelessWidget {
  final String groupId;

  const GroupDetailsScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group Details')),
      body: Center(child: Text('Group ID: $groupId')),
    );
  }
}

class ChatRoomScreen extends StatelessWidget {
  final String groupId;

  const ChatRoomScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Room')),
      body: Center(child: Text('Chat for Group: $groupId')),
    );
  }
}

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: const Center(child: Text('Edit Profile Screen')),
    );
  }
}

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: const Center(child: Text('Change Password Screen')),
    );
  }
}

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: const Center(child: Text('Achievements Screen')),
    );
  }
}

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subscription')),
      body: const Center(child: Text('Subscription Screen')),
    );
  }
}

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: const Center(child: Text('Payment Screen')),
    );
  }
}

class ChecklistScreen extends StatelessWidget {
  const ChecklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checklist')),
      body: const Center(child: Text('Checklist Screen')),
    );
  }
}

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChatbotPage();
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Screen')),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final Exception? error;

  const ErrorScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (error != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.explore),
              child: const Text('Go to Explore'),
            ),
          ],
        ),
      ),
    );
  }
}
