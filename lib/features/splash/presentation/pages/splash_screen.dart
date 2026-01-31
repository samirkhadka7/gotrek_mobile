import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../onboarding/presentation/pages/onboarding_main.dart';
import '../../../home/presentation/pages/bottom_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  bool _canNavigate = false;

  @override
  void initState() {
    super.initState();
    // Start minimum timer for splash display
    _timer = Timer(const Duration(seconds: 2), () {
      print('SplashScreen: Minimum splash time reached');
      setState(() {
        _canNavigate = true;
      });
      // Try to navigate immediately if auth state is already determined
      final currentState = context.read<AuthBloc>().state;
      if (currentState is! AuthInitial && currentState is! AuthLoading) {
        _navigateToNext(currentState);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _navigateToNext(AuthState state) {
    if (_canNavigate) {
      // Minimum splash time has passed
      if (state is AuthAuthenticated) {
        print('SplashScreen: Navigating to Home - User authenticated');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavigationScreen()),
        );
      } else {
        print('SplashScreen: Navigating to Onboarding - User not authenticated');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingMain()),
        );
      }
    } else {
      print('SplashScreen: Cannot navigate yet - minimum time not passed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        print('SplashScreen: Auth state changed to: $state');
        // Navigate when auth state is determined and minimum time has passed
        if (state is! AuthInitial && state is! AuthLoading) {
          _navigateToNext(state);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.blue.shade900,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              ClipRRect(
                borderRadius: BorderRadius.circular(70),
                child: Image.asset(
                  'assets/images/main.jpg',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(70),
                      ),
                      child: const Icon(
                        Icons.terrain,
                        size: 80,
                        color: Colors.blue,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // App Name
              const Text(
                'GOTrek',
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Tagline
              Text(
                'Explore the Himalayas',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),

              const SizedBox(height: 50),

              // Loading indicator
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}