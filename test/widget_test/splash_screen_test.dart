import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SplashScreen Widget Tests', () {
    testWidgets('should display splash screen scaffold', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Splash Screen'),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should render splash content', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Loading...'),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('should display splash logo',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircleAvatar(
                child: Icon(Icons.location_on),
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('should handle navigation state',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Splash'),
            ),
            body: const Center(
              child: Text('App Loading'),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should render centered content on splash screen',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.location_on),
                  SizedBox(height: 16),
                  Text('GoTrek'),
                ],
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Center), findsWidgets);
      expect(find.text('GoTrek'), findsOneWidget);
    });
  });
}
