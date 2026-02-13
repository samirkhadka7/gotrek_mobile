import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Material Widgets Integration Tests', () {
    testWidgets('should render scaffold with appbar',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Test App'),
            ),
            body: const Center(
              child: Text('Hello World'),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Test App'), findsOneWidget);
      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('should handle button taps', (WidgetTester tester) async {
      // Arrange
      var buttonTapped = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  buttonTapped = true;
                },
                child: const Text('Tap Me'),
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Tap Me'), findsOneWidget);

      // Act - Tap the button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Assert
      expect(buttonTapped, true);
    });

    testWidgets('should render list of items', (WidgetTester tester) async {
      // Arrange
      final items = ['Item 1', 'Item 2', 'Item 3'];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]),
                );
              },
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(3));
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
    });

    testWidgets('should display dialog on button press',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: tester.element(find.byType(ElevatedButton)),
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Dialog'),
                        content: const Text('This is a dialog'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // Act - Tap button to show dialog
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Dialog'), findsOneWidget);
      expect(find.text('This is a dialog'), findsOneWidget);
    });

    testWidgets('should scroll list view', (WidgetTester tester) async {
      // Arrange
      final items = List.generate(20, (index) => 'Item $index');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]),
                );
              },
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Item 0'), findsOneWidget);
      expect(find.text('Item 19'), findsNothing);

      // Act - Scroll down
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pumpAndSettle();

      // Assert - Item 19 should now be visible
      expect(find.text('Item 19'), findsWidgets);
    });
  });
}
