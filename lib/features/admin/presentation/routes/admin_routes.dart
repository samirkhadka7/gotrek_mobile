import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection/injection.dart';
import '../pages/admin_dashboard_page.dart';
import '../pages/admin_users_page.dart';
import '../pages/admin_trails_page.dart';
import '../bloc/admin_user_bloc.dart';
import '../bloc/admin_trail_bloc.dart';

/// Admin routes configuration
class AdminRoutes {
  static const String dashboard = '/admin/dashboard';
  static const String users = '/admin/users';
  static const String trails = '/admin/trails';

  /// Get admin route
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboard:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<AdminUserBloc>()),
              BlocProvider(create: (_) => sl<AdminTrailBloc>()),
            ],
            child: const AdminDashboardPage(),
          ),
        );

      case users:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<AdminUserBloc>(),
            child: const AdminUsersPage(),
          ),
        );

      case trails:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<AdminTrailBloc>(),
            child: const AdminTrailsPage(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Not Found')),
            body: const Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
