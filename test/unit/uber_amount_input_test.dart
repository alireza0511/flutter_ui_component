import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_component/flutter_ui_component.dart';

void main() {
  group('UberAmountInput Tests', () {
    testWidgets('should render with default properties', (WidgetTester tester) async {
      double? changedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberAmountInput(
              onChanged: (value) => changedValue = value,
              label: 'Amount',
            ),
          ),
        ),
      );

      expect(find.text('Amount'), findsOneWidget);
      expect(find.text('\$'), findsOneWidget);
      expect(find.byType(UberAmountInput), findsOneWidget);
    });

    testWidgets('should handle valid amount input', (WidgetTester tester) async {
      double? changedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberAmountInput(
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '25.50');
      await tester.pump();
      
      expect(changedValue, equals(25.50));
    });

    testWidgets('should validate minimum amount', (WidgetTester tester) async {
      double? changedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberAmountInput(
              onChanged: (value) => changedValue = value,
              minAmount: 10.0,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '5.0');
      await tester.pump();
      
      expect(changedValue, isNull);
      expect(find.text('Amount must be at least \$10'), findsOneWidget);
    });

    testWidgets('should validate maximum amount', (WidgetTester tester) async {
      double? changedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberAmountInput(
              onChanged: (value) => changedValue = value,
              maxAmount: 100.0,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '150.0');
      await tester.pump();
      
      expect(changedValue, isNull);
      expect(find.text('Amount cannot exceed \$100'), findsOneWidget);
    });

    testWidgets('should handle invalid input', (WidgetTester tester) async {
      double? changedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberAmountInput(
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'invalid');
      await tester.pump();
      
      expect(changedValue, isNull);
      expect(find.text('Please enter a valid amount'), findsOneWidget);
    });

    testWidgets('should handle custom currency', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberAmountInput(
              onChanged: (value) {},
              currency: '€',
            ),
          ),
        ),
      );

      expect(find.text('€'), findsOneWidget);
    });

    testWidgets('should respect initial value', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberAmountInput(
              onChanged: (value) {},
              initialValue: 42.75,
            ),
          ),
        ),
      );

      expect(find.text('42.75'), findsOneWidget);
    });

    testWidgets('should handle empty input', (WidgetTester tester) async {
      double? changedValue = 99.99;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberAmountInput(
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '');
      await tester.pump();
      
      expect(changedValue, isNull);
    });

    testWidgets('should be disabled when enabled is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberAmountInput(
              onChanged: (value) {},
              enabled: false,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, isFalse);
    });

    testWidgets('should have proper semantics', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberAmountInput(
              onChanged: (value) {},
              semanticLabel: 'Custom Amount Label',
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Custom Amount Label'), findsOneWidget);
    });
  });
}