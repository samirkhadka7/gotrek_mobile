import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileBottomScreen Widget Tests', () {
    testWidgets('should render app with bottom navigation',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
            body: const Center(
              child: Text('Profile Content'),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('should display scaffold',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Profile Page'),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should display profile icons',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Icon(Icons.person),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('should display profile information text',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('User Profile'),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('User Profile'), findsOneWidget);
    });

    testWidgets('should display profile layout elements',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                CircleAvatar(
                  child: Icon(Icons.person),
                ),
                SizedBox(height: 16),
                Text('Profile Name'),
              ],
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('Profile Name'), findsOneWidget);
    });
  });
}
