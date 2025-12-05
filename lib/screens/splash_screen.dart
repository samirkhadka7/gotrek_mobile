import 'package:flutter/material.dart';
import 'dart:async';
import 'onboarding/onboarding_main.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();
    // 3 second pachi next page ma jancha
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingMain()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Trek Icon
            // Icon(
            //   Icons.terrain,
            //   size: 120,
            //   color: Colors.white,
            // ),
            ClipRRect(
              borderRadius: BorderRadius.circular(70),
              child: Image.asset(
                'assets/images/main.jpg',
                width: 150,
                height: 150,
                fit: BoxFit.cover,

              ),
            ),
            SizedBox(height: 20),
            // App Name
            Text(
              'GOTrek',
              style: TextStyle(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Explore the Himalayas',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}