import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_component/flutter_ui_component.dart';

void main() {
  group('UberElevatedButton Tests', () {
    testWidgets('should render with default properties', (WidgetTester tester) async {
      bool wasPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberElevatedButton(
              onPressed: () => wasPressed = true,
              child: const Text('Test Button'),
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byType(UberElevatedButton), findsOneWidget);
      
      await tester.tap(find.byType(UberElevatedButton));
      expect(wasPressed, isTrue);
    });

    testWidgets('should handle different sizes', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: Column(
              children: [
                UberElevatedButton(
                  onPressed: () {},
                  size: UberElevatedButtonSize.small,
                  child: const Text('Small'),
                ),
                UberElevatedButton(
                  onPressed: () {},
                  size: UberElevatedButtonSize.medium,
                  child: const Text('Medium'),
                ),
                UberElevatedButton(
                  onPressed: () {},
                  size: UberElevatedButtonSize.large,
                  child: const Text('Large'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Small'), findsOneWidget);
      expect(find.text('Medium'), findsOneWidget);
      expect(find.text('Large'), findsOneWidget);
    });

    testWidgets('should handle different variants', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: Column(
              children: [
                UberElevatedButton(
                  onPressed: () {},
                  variant: UberElevatedButtonVariant.primary,
                  child: const Text('Primary'),
                ),
                UberElevatedButton(
                  onPressed: () {},
                  variant: UberElevatedButtonVariant.secondary,
                  child: const Text('Secondary'),
                ),
                UberElevatedButton(
                  onPressed: () {},
                  variant: UberElevatedButtonVariant.destructive,
                  child: const Text('Destructive'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Primary'), findsOneWidget);
      expect(find.text('Secondary'), findsOneWidget);
      expect(find.text('Destructive'), findsOneWidget);
    });

    testWidgets('should show loading state', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberElevatedButton(
              onPressed: () {},
              isLoading: true,
              child: const Text('Loading'),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading'), findsOneWidget);
    });

    testWidgets('should be disabled when enabled is false', (WidgetTester tester) async {
      bool wasPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberElevatedButton(
              onPressed: () => wasPressed = true,
              enabled: false,
              child: const Text('Disabled'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(UberElevatedButton));
      expect(wasPressed, isFalse);
    });

    testWidgets('should respect fullWidth property', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: UberElevatedButton(
                onPressed: () {},
                fullWidth: true,
                child: const Text('Full Width'),
              ),
            ),
          ),
        ),
      );

      final buttonWidget = tester.widget<SizedBox>(find.ancestor(
        of: find.byType(UberElevatedButton),
        matching: find.byType(SizedBox),
      ).first);
      
      expect(buttonWidget.width, equals(double.infinity));
    });

    testWidgets('should have proper semantics', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberElevatedButton(
              onPressed: () {},
              semanticLabel: 'Custom Label',
              child: const Text('Button'),
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Custom Label'), findsOneWidget);
    });
  });
}