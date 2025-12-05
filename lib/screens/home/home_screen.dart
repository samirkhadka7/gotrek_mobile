import 'package:flutter/material.dart';
import '../auth/login_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home,
              size: 100,
              color: Colors.blue.shade900,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Home!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'You are successfully logged in',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../auth/login_screen.dart';

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Trek Nepal'),
//         backgroundColor: Colors.green[700],
//         foregroundColor: Colors.white,
//         actions: [
//           // Logout Button
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () {
//               // Logout gare login page ma jancha
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(builder: (context) => LoginScreen()),
//                 (route) => false,
//               );
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Trek Icon
//             Icon(
//               Icons.landscape,
//               size: 100,
//               color: Colors.green[700],
//             ),
            
//             SizedBox(height: 20),
            
//             // Welcome Text
//             Text(
//               'Welcome Trekker!',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.green[800],
//               ),
//             ),
            
//             SizedBox(height: 10),
            
//             // Success Message
//             Text(
//               'Ready to explore the mountains?',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[600],
//               ),
//             ),
            
//             SizedBox(height: 40),
            
//             // Sample Trek Cards
//             Padding(
//               padding: EdgeInsets.all(20),
//               child: Card(
//                 child: Padding(
//                   padding: EdgeInsets.all(20),
//                   child: Column(
//                     children: [
//                       Icon(Icons.terrain, size: 50, color: Colors.green[700]),
//                       SizedBox(height: 10),
//                       Text(
//                         'Popular Treks',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         'Everest Base Camp\nAnnapurna Circuit\nLangtang Valley',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(color: Colors.grey[600]),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
