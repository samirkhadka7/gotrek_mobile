import 'package:flutter/material.dart';

class OnboardingScreen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Backpack Icon
            ClipRRect(
              child: Image.asset(
                'assets/images/Adventure.png',
                width: 500,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            
            SizedBox(height: 50),
            
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
            
            SizedBox(height: 20),
            
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
