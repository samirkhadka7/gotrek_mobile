import 'package:flutter/material.dart';
import 'onboarding_screen_1.dart';
import 'onboarding_screen_2.dart';
import 'onboarding_screen_3.dart';
import '../auth/login_screen.dart';

class OnboardingMain extends StatefulWidget {
  @override
  OnboardingMainState createState() => OnboardingMainState();
}

class OnboardingMainState extends State<OnboardingMain> {
  
  PageController pageController = PageController();
  
  
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(color: Colors.blue.shade900),
                  ),
                ),
              ],
            ),
            
          
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (int page) {
                  setState(() {
                    currentPage = page;
                  });
                },
                children: [
                  OnboardingScreen1(),
                  OnboardingScreen2(),
                  OnboardingScreen3(),
                ],
              ),
            ),
            
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Dot 1
                Container(
                  margin: EdgeInsets.all(5),
                  width: currentPage == 0 ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentPage == 0 ? Colors.blue.shade900 : Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                // Dot 2
                Container(
                  margin: EdgeInsets.all(5),
                  width: currentPage == 1 ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentPage == 1 ? Colors.blue.shade900 : Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                // Dot 3
                Container(
                  margin: EdgeInsets.all(5),
                  width: currentPage == 2 ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentPage == 2 ? Colors.blue.shade900 : Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 20),
            
            // Next Button
            Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                   
                    if (currentPage == 2) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    } 
                    
                    else {
                      pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  },
                  child: Text(
                    currentPage == 2 ? 'Start Trekking' : 'Next',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//////