import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gotrek/features/auth/presentation/widgets/auth_button.dart';

import 'package:gotrek/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:gotrek/features/home/presentation/widgets/stat_card.dart';
import 'package:gotrek/features/home/presentation/widgets/quick_action_button.dart';
import 'package:gotrek/features/home/presentation/widgets/feature_card.dart';
import 'package:gotrek/features/profile/presentation/widgets/profile_menu_item.dart';
import 'package:gotrek/features/trail/domain/entities/trail_entity.dart';
import 'package:gotrek/features/trail/presentation/widgets/trail_card.dart';

import '../helpers/test_helpers.dart';

/// Helper to wrap a widget with MaterialApp for testing
Widget buildTestableWidget(Widget child) {
  return MaterialApp(
    home: Scaffold(body: child),
  );
}

void main() {
  // ======================================================================
  // GROUP 1: AuthButton Widget Tests (4 tests)
  // ======================================================================
  group('AuthButton Widget', () {
    // WIDGET TEST 1
    testWidgets('displays text correctly', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        AuthButton(
          text: 'Login',
          onPressed: () {},
        ),
      ));

      expect(find.text('Login'), findsOneWidget);
    });

    // WIDGET TEST 2
    testWidgets('shows loading indicator when isLoading is true',
        (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        const AuthButton(
          text: 'Login',
          isLoading: true,
        ),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // WIDGET TEST 3
    testWidgets('calls onPressed when tapped', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(buildTestableWidget(
        AuthButton(
          text: 'Login',
          onPressed: () => pressed = true,
        ),
      ));

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });

    // WIDGET TEST 4
    testWidgets('renders outlined variant correctly', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        AuthButton(
          text: 'Sign Up',
          onPressed: () {},
          isOutlined: true,
        ),
      ));

      expect(find.text('Sign Up'), findsOneWidget);
    });
  });

  // ======================================================================
  // GROUP 2: AuthTextField Widget Tests (4 tests)
  // ======================================================================
  group('AuthTextField Widget', () {
    // WIDGET TEST 5
    testWidgets('displays label text', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(buildTestableWidget(
        AuthTextField(
          controller: controller,
          label: 'Email',
          hint: 'Enter your email',
        ),
      ));

      expect(find.text('Email'), findsOneWidget);
    });

    // WIDGET TEST 6
    testWidgets('accepts user input', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(buildTestableWidget(
        AuthTextField(
          controller: controller,
          label: 'Email',
          hint: 'Enter your email',
        ),
      ));

      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      expect(controller.text, 'test@example.com');
    });

    // WIDGET TEST 7
    testWidgets('shows validation error', (tester) async {
      final formKey = GlobalKey<FormState>();
      final controller = TextEditingController();

      await tester.pumpWidget(buildTestableWidget(
        Form(
          key: formKey,
          child: AuthTextField(
            controller: controller,
            label: 'Email',
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Email is required' : null,
          ),
        ),
      ));

      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);
    });

    // WIDGET TEST 8
    testWidgets('displays prefix icon when provided', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(buildTestableWidget(
        AuthTextField(
          controller: controller,
          label: 'Email',
          prefixIcon: Icons.email,
        ),
      ));

      expect(find.byIcon(Icons.email), findsOneWidget);
    });
  });

  // ======================================================================
  // GROUP 3: StatCard Widget Tests (3 tests)
  // ======================================================================
  group('StatCard Widget', () {
    // WIDGET TEST 9
    testWidgets('renders icon, value and label', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        const StatCard(
          icon: Icons.terrain,
          value: '15',
          label: 'Total Treks',
          color: Colors.green,
        ),
      ));

      expect(find.byIcon(Icons.terrain), findsOneWidget);
      expect(find.text('15'), findsOneWidget);
      expect(find.text('Total Treks'), findsOneWidget);
    });

    // WIDGET TEST 10
    testWidgets('displays zero values correctly', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        const StatCard(
          icon: Icons.timer,
          value: '0',
          label: 'Hours',
          color: Colors.blue,
        ),
      ));

      expect(find.text('0'), findsOneWidget);
      expect(find.text('Hours'), findsOneWidget);
    });

    // WIDGET TEST 11
    testWidgets('renders with custom color', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        const StatCard(
          icon: Icons.landscape,
          value: '4130',
          label: 'Elevation (m)',
          color: Colors.orange,
        ),
      ));

      final icon = tester.widget<Icon>(find.byIcon(Icons.landscape));
      expect(icon.color, Colors.orange);
    });
  });

  // ======================================================================
  // GROUP 4: QuickActionButton Widget Tests (3 tests)
  // ======================================================================
  group('QuickActionButton Widget', () {
    // WIDGET TEST 12
    testWidgets('renders icon and label', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        const QuickActionButton(
          icon: Icons.explore,
          label: 'Explore',
          color: Colors.blue,
        ),
      ));

      expect(find.byIcon(Icons.explore), findsOneWidget);
      expect(find.text('Explore'), findsOneWidget);
    });

    // WIDGET TEST 13
    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(buildTestableWidget(
        QuickActionButton(
          icon: Icons.group,
          label: 'Groups',
          color: Colors.purple,
          onTap: () => tapped = true,
        ),
      ));

      await tester.tap(find.text('Groups'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    // WIDGET TEST 14
    testWidgets('shows notification badge when showBadge is true',
        (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        const QuickActionButton(
          icon: Icons.notifications,
          label: 'Alerts',
          color: Colors.red,
          showBadge: true,
        ),
      ));

      // The badge Container has a red color decoration
      final decoratedContainers = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color == Colors.red,
      );
      expect(decoratedContainers, findsOneWidget);
    });
  });

  // ======================================================================
  // GROUP 5: FeatureCard Widget Tests (3 tests)
  // ======================================================================
  group('FeatureCard Widget', () {
    // WIDGET TEST 15
    testWidgets('renders title and description', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        SizedBox(
          height: 200,
          width: 200,
          child: FeatureCard(
            icon: Icons.map,
            title: 'Discover Trails',
            description: 'Find new routes to explore',
            gradient: const [Colors.blue, Colors.cyan],
            onTap: () {},
          ),
        ),
      ));

      expect(find.text('Discover Trails'), findsOneWidget);
      expect(find.text('Find new routes to explore'), findsOneWidget);
      expect(find.byIcon(Icons.map), findsOneWidget);
    });

    // WIDGET TEST 16
    testWidgets('calls onTap callback', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(buildTestableWidget(
        SizedBox(
          height: 200,
          width: 200,
          child: FeatureCard(
            icon: Icons.group,
            title: 'Groups',
            description: 'Join a group',
            gradient: const [Colors.green, Colors.teal],
            onTap: () => tapped = true,
          ),
        ),
      ));

      await tester.tap(find.text('Groups'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    // WIDGET TEST 17
    testWidgets('displays badge when provided', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        SizedBox(
          height: 200,
          width: 200,
          child: FeatureCard(
            icon: Icons.star,
            title: 'Premium',
            description: 'Upgrade now',
            gradient: const [Colors.amber, Colors.orange],
            badge: 'NEW',
          ),
        ),
      ));

      expect(find.text('NEW'), findsOneWidget);
    });
  });

  // ======================================================================
  // GROUP 6: ProfileMenuItem Widget Tests (3 tests)
  // ======================================================================
  group('ProfileMenuItem Widget', () {
    // WIDGET TEST 18
    testWidgets('renders icon, title, and subtitle', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        const ProfileMenuItem(
          icon: Icons.person,
          title: 'Edit Profile',
          subtitle: 'Update your personal info',
        ),
      ));

      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('Update your personal info'), findsOneWidget);
    });

    // WIDGET TEST 19
    testWidgets('calls onTap when pressed', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(buildTestableWidget(
        ProfileMenuItem(
          icon: Icons.settings,
          title: 'Settings',
          onTap: () => tapped = true,
        ),
      ));

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    // WIDGET TEST 20
    testWidgets('renders without subtitle when not provided', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        const ProfileMenuItem(
          icon: Icons.logout,
          title: 'Logout',
          color: Colors.red,
        ),
      ));

      expect(find.text('Logout'), findsOneWidget);
      // Subtitle should not be present
      expect(find.text('Update your personal info'), findsNothing);
    });
  });
}
