import 'package:flutter/material.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/Dodhara.png',
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => Container(
        color: const Color(0xFF4A1800),
        child: const Icon(Icons.map_outlined, size: 120, color: Colors.white24),
      ),
    );
  }
}
