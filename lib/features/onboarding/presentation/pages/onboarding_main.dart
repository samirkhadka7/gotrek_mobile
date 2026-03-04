import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/constants/storage_constants.dart';
import 'onboarding_screen_1.dart';
import 'onboarding_screen_2.dart';
import 'onboarding_screen_3.dart';

// ── Per-page data ──────────────────────────────────────────────────────────────
class _PageData {
  final String title;
  final String subtitle;
  final String description;
  final String badgeLabel;
  final IconData badgeIcon;
  final Color accent;

  const _PageData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.badgeLabel,
    required this.badgeIcon,
    required this.accent,
  });
}

const List<_PageData> _pages = [
  _PageData(
    title: 'Discover',
    subtitle: 'Nepal',
    description:
        'Explore the most beautiful trekking routes in Nepal. From Everest to Annapurna, discover hidden gems waiting for you.',
    badgeLabel: 'EXPLORE',
    badgeIcon: Icons.terrain_rounded,
    accent: Color(0xFF69F0AE), // bright green
  ),
  _PageData(
    title: 'Plan Your',
    subtitle: 'Trek',
    description:
        'Get detailed information about routes, difficulty levels, best seasons, and all required permits for your journey.',
    badgeLabel: 'PLAN',
    badgeIcon: Icons.map_outlined,
    accent: Color(0xFFFF8A65), // soft orange
  ),
  _PageData(
    title: 'Adventure',
    subtitle: 'Awaits',
    description:
        'Connect with fellow trekkers, join groups, and get real-time updates. Your Himalayan adventure starts right here!',
    badgeLabel: 'ADVENTURE',
    badgeIcon: Icons.hiking_rounded,
    accent: Color(0xFF64B5F6), // sky blue
  ),
];

// ── Main Widget ────────────────────────────────────────────────────────────────
class OnboardingMain extends StatefulWidget {
  const OnboardingMain({super.key});

  @override
  State<OnboardingMain> createState() => _OnboardingMainState();
}

class _OnboardingMainState extends State<OnboardingMain>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late final AnimationController _textController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fadeAnim =
        CurvedAnimation(parent: _textController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.14),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic));
    _textController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    _textController.reset();
    _textController.forward();
  }

  void _goToLogin() {
    final settingsBox = Hive.box<dynamic>(StorageConstants.settingsBox);
    settingsBox.put(StorageConstants.onboardingCompleted, true);
    context.go(AppRoutes.login);
  }

  void _nextPage() {
    if (_currentPage == _pages.length - 1) {
      _goToLogin();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final data = _pages[_currentPage];
    final isLast = _currentPage == _pages.length - 1;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // ── 1. Full-screen image PageView ─────────────────────────────
            SizedBox.expand(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: const [
                  OnboardingScreen1(),
                  OnboardingScreen2(),
                  OnboardingScreen3(),
                ],
              ),
            ),

            // ── 2. Multi-stop dark gradient overlay ───────────────────────
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.15),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.20),
                      Colors.black.withValues(alpha: 0.72),
                      Colors.black.withValues(alpha: 0.93),
                    ],
                    stops: const [0.0, 0.20, 0.45, 0.70, 1.0],
                  ),
                ),
              ),
            ),

            // ── 3. Top bar: page counter + Skip ──────────────────────────
            Positioned(
              top: topPad + 16,
              left: 24,
              right: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // "01 / 03" counter
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: (_currentPage + 1)
                              .toString()
                              .padLeft(2, '0'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' / ${_pages.length.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.45),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Skip button
                  GestureDetector(
                    onTap: _goToLogin,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 9),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.22),
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── 4. Bottom content ─────────────────────────────────────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding:
                    EdgeInsets.fromLTRB(28, 0, 28, bottomPad + 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Badge chip
                    FadeTransition(
                      opacity: _fadeAnim,
                      child: SlideTransition(
                        position: _slideAnim,
                        child: _BadgeChip(
                          icon: data.badgeIcon,
                          label: data.badgeLabel,
                          color: data.accent,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Title line 1 — light weight
                    FadeTransition(
                      opacity: _fadeAnim,
                      child: SlideTransition(
                        position: _slideAnim,
                        child: Text(
                          data.title,
                          style: const TextStyle(
                            fontSize: 46,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                            height: 1.05,
                            letterSpacing: -1.2,
                          ),
                        ),
                      ),
                    ),

                    // Title line 2 — bold + accent colour
                    FadeTransition(
                      opacity: _fadeAnim,
                      child: SlideTransition(
                        position: _slideAnim,
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 400),
                          style: TextStyle(
                            fontSize: 46,
                            fontWeight: FontWeight.w800,
                            color: data.accent,
                            height: 1.05,
                            letterSpacing: -1.2,
                          ),
                          child: Text(data.subtitle),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Description
                    FadeTransition(
                      opacity: _fadeAnim,
                      child: SlideTransition(
                        position: _slideAnim,
                        child: Text(
                          data.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.68),
                            height: 1.75,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 38),

                    // Dots + action button row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Animated pill dots
                        Row(
                          children: List.generate(_pages.length, (i) {
                            final active = i == _currentPage;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeInOut,
                              margin: const EdgeInsets.only(right: 8),
                              width: active ? 32 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: active
                                    ? data.accent
                                    : Colors.white.withValues(alpha: 0.28),
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: active
                                    ? [
                                        BoxShadow(
                                          color: data.accent
                                              .withValues(alpha: 0.55),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        )
                                      ]
                                    : null,
                              ),
                            );
                          }),
                        ),

                        const Spacer(),

                        // Next button (circle) or Get Started (pill)
                        if (isLast)
                          _GetStartedButton(
                              onTap: _nextPage, color: data.accent)
                        else
                          _CircleNextButton(
                              onTap: _nextPage, color: data.accent),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable Widgets ───────────────────────────────────────────────────────────

class _BadgeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _BadgeChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 7),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 11,
              letterSpacing: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleNextButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;

  const _CircleNextButton({required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        width: 62,
        height: 62,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.50),
              blurRadius: 22,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_forward_rounded,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }
}

class _GetStartedButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;

  const _GetStartedButton({required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        padding:
            const EdgeInsets.symmetric(horizontal: 28, vertical: 17),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(34),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.52),
              blurRadius: 26,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Get Started',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
                letterSpacing: 0.3,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.rocket_launch_rounded,
                color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}
