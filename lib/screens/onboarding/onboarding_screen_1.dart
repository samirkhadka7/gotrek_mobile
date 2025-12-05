import 'package:flutter/material.dart';

class OnboardingScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mountain Icon
            ClipRRect(
              // borderRadius: BorderRadius.circular(70),
              child: Image.asset(
                'assets/images/Gau.png',
                width: 600,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            
            SizedBox(height: 50),
            
            // Title
            Text(
              'Discover Nepal',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Description
            Text(
              'Explore the most beautiful trekking routes in Nepal. From Everest to Annapurna, discover hidden gems.',
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