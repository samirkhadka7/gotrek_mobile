import 'package:flutter/material.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

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
                'assets/images/Adventure.png',
                width: 500,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 250,
                    child: Icon(
                      Icons.hiking,
                      size: 150,
                      color: Colors.blue[300],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 50),
            
            // Title
            Text(
              'Ready to Adventure',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 20),
            
            // Description
            Text(
              'Connect with guides, book your trek, and get real-time updates. Your Himalayan adventure starts here!',
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