import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:gotrek/core/constants/hive_constants.dart';
import 'package:gotrek/core/services/hive_service.dart';
import 'package:gotrek/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:gotrek/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:gotrek/features/auth/domain/usecases/register_user.dart';
import 'package:gotrek/features/auth/domain/usecases/login_user.dart';
import 'package:gotrek/features/auth/domain/usecases/is_user_registered.dart';
import 'package:gotrek/features/auth/presentation/providers/auth_provider.dart';
import 'package:gotrek/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await HiveService.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthLocalDataSource>(
          create: (_) => AuthLocalDataSourceImpl(Hive.box(HiveConstants.userBox)),
        ),
        Provider<AuthRepositoryImpl>(
          create: (context) => AuthRepositoryImpl(context.read<AuthLocalDataSource>()),
        ),
        Provider<RegisterUser>(
          create: (context) => RegisterUser(context.read<AuthRepositoryImpl>()),
        ),
        Provider<LoginUser>(
          create: (context) => LoginUser(context.read<AuthRepositoryImpl>()),
        ),
        Provider<IsUserRegistered>(
          create: (context) => IsUserRegistered(context.read<AuthRepositoryImpl>()),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            registerUser: context.read<RegisterUser>(),
            loginUser: context.read<LoginUser>(),
            isUserRegistered: context.read<IsUserRegistered>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Trek Nepal',
        home: SplashScreen(),
      ),
    );
  }
}