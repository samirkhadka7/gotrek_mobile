import 'package:flutter/material.dart';

class OnboardingScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Map Icon
            ClipRRect(
              // borderRadius: BorderRadius.circular(70),
              child: Image.asset(
                'assets/images/Dodhara.png',
                width: 500,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            
            SizedBox(height: 50),
            
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
            
            SizedBox(height: 20),
            
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

