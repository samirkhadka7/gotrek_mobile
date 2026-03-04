import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/constants/storage_constants.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  bool _animationDone = false;
  bool _authChecked = false;

  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _subtitleFadeAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnim = Tween<double>(begin: 0.72, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack),
      ),
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
      ),
    );

    _subtitleFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    // Wait for minimum splash duration
    _timer = Timer(const Duration(milliseconds: 1500), () {
      _animationDone = true;
      _tryNavigate();
    });

    // Listen for auth check completion
    _waitForAuthCheck();
  }

  void _waitForAuthCheck() {
    final authBloc = context.read<AuthBloc>();
    final currentState = authBloc.state;

    // If auth is already resolved, mark as checked
    if (currentState is! AuthInitial && currentState is! AuthLoading) {
      _authChecked = true;
      return;
    }

    // Otherwise listen for auth state to resolve
    late final dynamic subscription;
    subscription = authBloc.stream.listen((state) {
      if (state is! AuthInitial && state is! AuthLoading) {
        _authChecked = true;
        subscription.cancel();
        _tryNavigate();
      }
    });
  }

  void _tryNavigate() {
    if (!_animationDone || !_authChecked) return;
    _navigate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _navigate() {
    if (!mounted) return;

    // Check if user is already authenticated
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.go(AppRoutes.home);
      return;
    }

    bool onboardingDone = false;
    try {
      final box = Hive.box<dynamic>(StorageConstants.settingsBox);
      final value = box.get(StorageConstants.onboardingCompleted);
      onboardingDone = value == true;
      debugPrint(
          '[Splash] onboardingCompleted: $value → done=$onboardingDone');
    } catch (e) {
      debugPrint('[Splash] Hive read error: $e — defaulting to onboarding');
      onboardingDone = false;
    }

    if (!mounted) return;

    if (onboardingDone) {
      context.go(AppRoutes.login);
    } else {
      context.go(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
                const Color(0xFF0D4D4D),
              ],
              stops: const [0.0, 0.55, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // ── Decorative circles ─────────────────────────────────
              Positioned(
                top: -80,
                right: -80,
                child: _Circle(size: 280, opacity: 0.06),
              ),
              Positioned(
                top: 60,
                right: 120,
                child: _Circle(size: 80, opacity: 0.05),
              ),
              Positioned(
                bottom: -100,
                left: -60,
                child: _Circle(size: 300, opacity: 0.05),
              ),
              Positioned(
                bottom: 120,
                right: -40,
                child: _Circle(size: 160, opacity: 0.04),
              ),

              // ── Main content ───────────────────────────────────────
              SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (_, child) => Opacity(
                          opacity: _fadeAnim.value,
                          child: Transform.scale(
                            scale: _scaleAnim.value,
                            child: child,
                          ),
                        ),
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.35),
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 32,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/main.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.white.withValues(alpha: 0.15),
                                child: const Icon(
                                  Icons.terrain_rounded,
                                  size: 52,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // App name
                      FadeTransition(
                        opacity: _fadeAnim,
                        child: const Text(
                          'GoTrek',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 44,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Tagline
                      FadeTransition(
                        opacity: _subtitleFadeAnim,
                        child: Text(
                          'Explore Nepal\'s Majestic Trails',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.78),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Bottom loading indicator ────────────────────────────
              Positioned(
                bottom: 48,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _subtitleFadeAnim,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 36,
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          minHeight: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  final double size;
  final double opacity;
  const _Circle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}
