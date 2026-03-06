import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_component/flutter_ui_component.dart';

import '../test_helpers.dart';

void main() {
  group('AccountSelectionHeader', () {
    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const AccountSelectionHeader(title: 'Transfer From'),
      ));

      expect(find.text('Transfer From'), findsOneWidget);
    });

    testWidgets('renders subtitle when provided', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const AccountSelectionHeader(
          title: 'Transfer From',
          subtitle: 'Select an account',
        ),
      ));

      expect(find.text('Transfer From'), findsOneWidget);
      expect(find.text('Select an account'), findsOneWidget);
    });

    testWidgets('does not render subtitle when null', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const AccountSelectionHeader(title: 'Transfer From'),
      ));

      expect(find.text('Transfer From'), findsOneWidget);
      // Only title text widget
      final texts = tester.widgetList<Text>(find.byType(Text));
      expect(texts.length, 1);
    });

    testWidgets('shows close button when showCloseButton is true',
        (tester) async {
      await tester.pumpWidget(wrapInApp(
        const AccountSelectionHeader(
          title: 'Title',
          showCloseButton: true,
        ),
      ));

      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byTooltip('Close'), findsOneWidget);
    });

    testWidgets('hides close button when showCloseButton is false',
        (tester) async {
      await tester.pumpWidget(wrapInApp(
        const AccountSelectionHeader(
          title: 'Title',
          showCloseButton: false,
        ),
      ));

      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('calls onClose when close button tapped', (tester) async {
      bool closed = false;

      await tester.pumpWidget(wrapInApp(
        AccountSelectionHeader(
          title: 'Title',
          showCloseButton: true,
          onClose: () => closed = true,
        ),
      ));

      await tester.tap(find.byIcon(Icons.close));
      expect(closed, true);
    });
  });
}
