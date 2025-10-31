import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_component/flutter_ui_component.dart';

void main() {
  group('UberTextInput Tests', () {
    testWidgets('should render with default properties', (WidgetTester tester) async {
      String? changedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberTextInput(
              onChanged: (value) => changedValue = value,
              label: 'Text Input',
            ),
          ),
        ),
      );

      expect(find.text('Text Input'), findsOneWidget);
      expect(find.byType(UberTextInput), findsOneWidget);
    });

    testWidgets('should handle text input', (WidgetTester tester) async {
      String? changedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberTextInput(
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Hello World');
      await tester.pump();
      
      expect(changedValue, equals('Hello World'));
    });

    testWidgets('should handle email type', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberTextInput(
              onChanged: (value) {},
              type: UberTextInputType.email,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.keyboardType, equals(TextInputType.emailAddress));
    });

    testWidgets('should handle password type with visibility toggle', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberTextInput(
              onChanged: (value) {},
              type: UberTextInputType.password,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);
      
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();
      
      final updatedTextField = tester.widget<TextField>(find.byType(TextField));
      expect(updatedTextField.obscureText, isFalse);
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('should handle multiline type', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberTextInput(
              onChanged: (value) {},
              type: UberTextInputType.multiline,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.keyboardType, equals(TextInputType.multiline));
      expect(textField.maxLines, equals(5));
      expect(textField.minLines, equals(3));
    });

    testWidgets('should handle custom validation', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberTextInput(
              onChanged: (value) {},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Field is required';
                }
                if (value.length < 3) {
                  return 'Must be at least 3 characters';
                }
                return null;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Hi');
      await tester.pump();
      
      expect(find.text('Must be at least 3 characters'), findsOneWidget);
    });

    testWidgets('should respect initial value', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberTextInput(
              onChanged: (value) {},
              initialValue: 'Initial Text',
            ),
          ),
        ),
      );

      expect(find.text('Initial Text'), findsOneWidget);
    });

    testWidgets('should handle max length', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberTextInput(
              onChanged: (value) {},
              maxLength: 10,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Hello');
      await tester.pump();
      
      expect(find.text('5/10'), findsOneWidget);
    });

    testWidgets('should be disabled when enabled is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberTextInput(
              onChanged: (value) {},
              enabled: false,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, isFalse);
    });

    testWidgets('should handle prefix and suffix icons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberTextInput(
              onChanged: (value) {},
              prefixIcon: const Icon(Icons.search),
              suffixIcon: const Icon(Icons.clear),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('should have proper semantics', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberTextInput(
              onChanged: (value) {},
              semanticLabel: 'Custom Text Label',
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Custom Text Label'), findsOneWidget);
    });
  });
}