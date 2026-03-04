import 'package:flutter/material.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/Gau.png',
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => Container(
        color: const Color(0xFF1B4332),
        child: const Icon(Icons.landscape, size: 120, color: Colors.white24),
      ),
    );
  }
}
