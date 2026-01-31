import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/network/hive_service.dart';
import 'app/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/splash/presentation/pages/splash_screen.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  await di.initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<AuthBloc>()..add(CheckAuthStatusEvent()),
      child: MaterialApp(
        title: 'GOTrek',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.getApplicationTheme(),
        home: SplashScreen(),
      ),
    );
  }
}