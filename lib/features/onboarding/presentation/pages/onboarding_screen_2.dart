import 'package:flutter/material.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image
            ClipRRect(
              child: Image.asset(
                'assets/images/Dodhara.png',
                width: 500,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 250,
                    child: Icon(
                      Icons.map,
                      size: 150,
                      color: Colors.orange[300],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 50),
            
            // Title
            Text(
              'Plan Your Trek',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.orange[800],
              ),
            ),
            const SizedBox(height: 20),
            
            // Description
            Text(
              'Get detailed information about trek routes, difficulty levels, best seasons, and required permits.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}