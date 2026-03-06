import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_component/flutter_ui_component.dart';

import '../test_helpers.dart';

void main() {
  group('AccountCard', () {
    testWidgets('renders display name and details', (tester) async {
      final account = sampleAccountItem();

      await tester.pumpWidget(wrapInApp(
        AccountCard(account: account),
      ));

      expect(find.text('Premier Savings'), findsOneWidget);
      expect(find.text('Account Type'), findsOneWidget);
      expect(find.text('SAVINGS'), findsOneWidget);
      expect(find.text('Available Balance'), findsOneWidget);
      expect(find.text('\$87.49'), findsOneWidget);
    });

    testWidgets('shows selection bar when isSelected is true', (tester) async {
      await tester.pumpWidget(wrapInApp(
        AccountCard(
          account: sampleAccountItem(),
          isSelected: true,
        ),
      ));

      final bar = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = bar.decoration as BoxDecoration;
      expect(decoration.color, isNot(Colors.transparent));
    });

    testWidgets('selection bar is transparent when not selected',
        (tester) async {
      await tester.pumpWidget(wrapInApp(
        AccountCard(
          account: sampleAccountItem(),
          isSelected: false,
        ),
      ));

      final bar = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = bar.decoration as BoxDecoration;
      expect(decoration.color, Colors.transparent);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(wrapInApp(
        AccountCard(
          account: sampleAccountItem(),
          onTap: () => tapped = true,
        ),
      ));

      await tester.tap(find.byType(AccountCard));
      expect(tapped, true);
    });

    testWidgets('disabled account has reduced opacity', (tester) async {
      await tester.pumpWidget(wrapInApp(
        AccountCard(account: sampleDisabledAccountItem()),
      ));

      final opacity = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacity.opacity, 0.4);
    });

    testWidgets('disabled account does not respond to tap', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(wrapInApp(
        AccountCard(
          account: sampleDisabledAccountItem(),
          onTap: () => tapped = true,
        ),
      ));

      await tester.tap(find.byType(InkWell));
      expect(tapped, false);
    });

    testWidgets('enabled account has full opacity', (tester) async {
      await tester.pumpWidget(wrapInApp(
        AccountCard(account: sampleAccountItem()),
      ));

      final opacity = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacity.opacity, 1.0);
    });

    testWidgets('selected card has higher elevation', (tester) async {
      await tester.pumpWidget(wrapInApp(
        AccountCard(
          account: sampleAccountItem(),
          isSelected: true,
        ),
      ));

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 2);
    });

    testWidgets('unselected card has default elevation', (tester) async {
      await tester.pumpWidget(wrapInApp(
        AccountCard(
          account: sampleAccountItem(),
          isSelected: false,
        ),
      ));

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 1);
    });
  });
}
