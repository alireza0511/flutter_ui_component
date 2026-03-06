import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_component/flutter_ui_component.dart';

import '../test_helpers.dart';

void main() {
  group('InfoBanner', () {
    testWidgets('renders message text', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const InfoBanner(message: 'Only eligible accounts shown.'),
      ));

      expect(find.text('Only eligible accounts shown.'), findsOneWidget);
    });

    testWidgets('shows info icon', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const InfoBanner(message: 'Test message'),
      ));

      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('renders with dark theme', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const InfoBanner(message: 'Dark mode message'),
        theme: UberTheme.darkTheme,
      ));

      expect(find.text('Dark mode message'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });
  });
}
