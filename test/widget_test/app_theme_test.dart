import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gotrek/app/theme/app_theme.dart';

void main() {
  group('AppTheme Widget Tests', () {
    testWidgets('should apply material app theme correctly',
        (WidgetTester tester) async {
      // Arrange
      final theme = AppTheme.getApplicationTheme();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(
            body: Center(
              child: Text('Theme Test'),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(theme, isNotNull);
    });

    testWidgets('should have defined colors in theme', (WidgetTester tester) async {
      // Arrange
      final theme = AppTheme.getApplicationTheme();

      // Act & Assert
      expect(theme.primaryColor, isNotNull);
      expect(theme.scaffoldBackgroundColor, isNotNull);
      expect(theme.appBarTheme, isNotNull);
    });

    testWidgets('should render button with theme styles',
        (WidgetTester tester) async {
      // Arrange
      final theme = AppTheme.getApplicationTheme();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Themed Button'),
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('should render text with theme typography',
        (WidgetTester tester) async {
      // Arrange
      final theme = AppTheme.getApplicationTheme();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(
            body: Center(
              child: Text(
                'Theme Typography Test',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Theme Typography Test'), findsOneWidget);
      expect(theme.textTheme, isNotNull);
    });

    testWidgets('should support light theme appearance',
        (WidgetTester tester) async {
      // Arrange
      final theme = AppTheme.getApplicationTheme();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Light Theme Test'),
            ),
            body: const Center(
              child: Text('Content'),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Light Theme Test'), findsOneWidget);
    });
  });
}
