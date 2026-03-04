import 'package:flutter/material.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/Adventure.png',
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => Container(
        color: const Color(0xFF0D1B3E),
        child: const Icon(Icons.hiking, size: 120, color: Colors.white24),
      ),
    );
  }
}
