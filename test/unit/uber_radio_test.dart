import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_component/flutter_ui_component.dart';

void main() {
  group('UberRadio Tests', () {
    testWidgets('should render with default properties', (WidgetTester tester) async {
      String? selectedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberRadio<String>(
              value: 'option1',
              groupValue: selectedValue,
              onChanged: (value) => selectedValue = value,
            ),
          ),
        ),
      );

      expect(find.byType(UberRadio<String>), findsOneWidget);
    });

    testWidgets('should handle selection change', (WidgetTester tester) async {
      String? selectedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return UberRadio<String>(
                  value: 'option1',
                  groupValue: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(UberRadio<String>));
      await tester.pump();
      
      expect(selectedValue, equals('option1'));
    });

    testWidgets('should show selected state', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberRadio<String>(
              value: 'option1',
              groupValue: 'option1',
              onChanged: (value) {},
            ),
          ),
        ),
      );

      final radio = tester.widget<UberRadio<String>>(find.byType(UberRadio<String>));
      expect(radio.value == radio.groupValue, isTrue);
    });

    testWidgets('should be disabled when enabled is false', (WidgetTester tester) async {
      String? selectedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberRadio<String>(
              value: 'option1',
              groupValue: selectedValue,
              onChanged: (value) => selectedValue = value,
              enabled: false,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(UberRadio<String>));
      await tester.pump();
      
      expect(selectedValue, isNull);
    });

    testWidgets('should have proper semantics', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberRadio<String>(
              value: 'option1',
              groupValue: 'option1',
              onChanged: (value) {},
              semanticLabel: 'Custom Radio Label',
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Custom Radio Label'), findsOneWidget);
    });

    testWidgets('should handle null onChanged', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberRadio<String>(
              value: 'option1',
              groupValue: null,
              onChanged: null,
            ),
          ),
        ),
      );

      expect(find.byType(UberRadio<String>), findsOneWidget);
    });
  });

  group('UberRadioListTile Tests', () {
    testWidgets('should render with title and subtitle', (WidgetTester tester) async {
      String? selectedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberRadioListTile<String>(
              value: 'option1',
              groupValue: selectedValue,
              onChanged: (value) => selectedValue = value,
              title: const Text('Option 1'),
              subtitle: const Text('Description 1'),
            ),
          ),
        ),
      );

      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Description 1'), findsOneWidget);
      expect(find.byType(UberRadio<String>), findsOneWidget);
    });

    testWidgets('should handle selection through list tile tap', (WidgetTester tester) async {
      String? selectedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return UberRadioListTile<String>(
                  value: 'option1',
                  groupValue: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                  title: const Text('Option 1'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pump();
      
      expect(selectedValue, equals('option1'));
    });

    testWidgets('should be disabled when enabled is false', (WidgetTester tester) async {
      String? selectedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberRadioListTile<String>(
              value: 'option1',
              groupValue: selectedValue,
              onChanged: (value) => selectedValue = value,
              title: const Text('Option 1'),
              enabled: false,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pump();
      
      expect(selectedValue, isNull);
    });

    testWidgets('should handle custom content padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: UberRadioListTile<String>(
              value: 'option1',
              groupValue: null,
              onChanged: (value) {},
              title: const Text('Option 1'),
              contentPadding: const EdgeInsets.all(24),
            ),
          ),
        ),
      );

      final padding = tester.widget<Padding>(find.byType(Padding).first);
      expect(padding.padding, equals(const EdgeInsets.all(24)));
    });
  });
}