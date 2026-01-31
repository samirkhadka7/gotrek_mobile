import 'package:flutter/material.dart';
import '../widgets/trek_card.dart';

class HomeBottomScreen extends StatelessWidget {
  const HomeBottomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search trails...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Hero Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
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
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Discover Your\nNext Adventure',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Explore breathtaking trails from\naround the world, connect with fellow\ntrekkers, and create unforgettable\nmemories.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF0D4D4D),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Explore Now',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 20),
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

          const SizedBox(height: 24),

          // Explore Trails Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Explore Trails',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Trek Cards
          const Padding(
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

          const SizedBox(height: 16),

          const Padding(
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

          const SizedBox(height: 16),

          const Padding(
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

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}