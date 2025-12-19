// import 'package:flutter/material.dart';

// class HomeBottomScreen extends StatefulWidget {
//   const HomeBottomScreen({super.key});

//   @override
//   State<HomeBottomScreen> createState() => _HomeBottomScreenState();
// }

// class _HomeBottomScreenState extends State<HomeBottomScreen> {
//   final TextEditingController _num1Controller = TextEditingController();
//   final TextEditingController _num2Controller = TextEditingController();
//   String _result = "";

//   void _calculateSum() {
//     final double num1 = double.tryParse(_num1Controller.text) ?? 0;
//     final double num2 = double.tryParse(_num2Controller.text) ?? 0;
//     final double sum = num1 + num2;

//     setState(() {
//       _result = "Sum: $sum";
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           TextField(
//             controller: _num1Controller,
//             keyboardType: TextInputType.number,
//             decoration: const InputDecoration(
//               labelText: "Enter first number",
//             ),
//           ),
//           const SizedBox(height: 16),
//           TextField(
//             controller: _num2Controller,
//             keyboardType: TextInputType.number,
//             decoration: const InputDecoration(
//               labelText: "Enter second number",
//             ),
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton(
//             onPressed: _calculateSum,
//             child: const Text("Calculate"),
//           ),
//           const SizedBox(height: 24),
//           Text(
//             _result,
//             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
// }























import 'package:flutter/material.dart';

class HomeBottomScreen extends StatefulWidget {
  const HomeBottomScreen({super.key});

  @override
  State<HomeBottomScreen> createState() => _HomeBottomScreenState();
}

class _HomeBottomScreenState extends State<HomeBottomScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search trails...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          
          // Hero Section - Discover Adventure
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0D4D4D),
                    Color(0xFF2D7A5A),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Background pattern
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Opacity(
                      opacity: 0.2,
                      child: Icon(
                        Icons.terrain,
                        size: 200,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Discover Your\nNext Adventure',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Explore breathtaking trails from\naround the world, connect with fellow\ntrekkers, and create unforgettable\nmemories.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFF0D4D4D),
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Explore Now',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 24),
          
          // Explore Trails Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Explore Trails',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          SizedBox(height: 16),
          
          // Trek Card 1 - Langtang Valley
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TrekCard(
              imagePath: 'assets/images/Langtang_Valley.jpg',
              name: 'Langtang Valley',
              location: 'Nepal',
              days: '7 days',
              rating: 4.8,
              reviews: 324,
              difficulty: 'Hard',
            ),
          ),
          
          SizedBox(height: 16),
          
          // Trek Card 2 - Everest Base Camp
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TrekCard(
              imagePath: 'assets/images/everest.jpg',
              name: 'Everest Base Camp',
              location: 'Nepal',
              days: '14 days',
              rating: 4.9,
              reviews: 512,
              difficulty: 'Hard',
            ),
          ),
          
          SizedBox(height: 16),
          
          // Trek Card 3 - Annapurna Circuit
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TrekCard(
              imagePath: 'assets/images/annapurna.jpg',
              name: 'Annapurna Circuit',
              location: 'Nepal',
              days: '15 days',
              rating: 4.7,
              reviews: 289,
              difficulty: 'Hard',
            ),
          ),
          
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

// Trek Card Widget - Same file ma rakhnu
class TrekCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String location;
  final String days;
  final double rating;
  final int reviews;
  final String difficulty;

  const TrekCard({
    Key? key,
    required this.imagePath,
    required this.name,
    required this.location,
    required this.days,
    required this.rating,
    required this.reviews,
    required this.difficulty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trek Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  imagePath,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Image load hudaina bhane placeholder
                    return Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(
                          Icons.terrain,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Difficulty Badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    difficulty,
                    style: TextStyle(
                      color: Colors.red[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Trek Details
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trek Name
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                SizedBox(height: 8),
                
                // Location
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Text(
                      location,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 8),
                
                // Duration
                Row(
                  children: [
                    Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Text(
                      days,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 12),
                
                // Rating
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    Icon(Icons.star_outline, color: Colors.amber, size: 20),
                    SizedBox(width: 8),
                    Text(
                      '$rating',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '($reviews)',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 16),
                
                // View Details Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // View details functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}