import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_component/flutter_ui_component.dart';

import '../test_helpers.dart';

void main() {
  group('AccountGroupHeader', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const AccountGroupHeader(label: 'CASH'),
      ));

      expect(find.text('CASH'), findsOneWidget);
    });

    testWidgets('renders optional subLabel widget', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const AccountGroupHeader(
          label: 'CASH',
          subLabel: Text('2 accounts'),
        ),
      ));

      expect(find.text('CASH'), findsOneWidget);
      expect(find.text('2 accounts'), findsOneWidget);
    });

    testWidgets('does not render subLabel when null', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const AccountGroupHeader(label: 'CREDIT'),
      ));

      // Only the label text should exist
      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      expect(textWidgets.length, 1);
    });
  });
}
