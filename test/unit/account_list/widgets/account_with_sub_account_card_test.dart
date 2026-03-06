import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_component/flutter_ui_component.dart';

import '../test_helpers.dart';

void main() {
  group('AccountWithSubAccountsCard', () {
    testWidgets('renders parent account name', (tester) async {
      await tester.pumpWidget(wrapInApp(
        AccountWithSubAccountsCard(
          account: sampleAccountItemWithSubs(),
        ),
      ));

      expect(find.text('Premier Savings'), findsOneWidget);
    });

    testWidgets('renders sub-account tiles for each subItem', (tester) async {
      await tester.pumpWidget(wrapInApp(
        AccountWithSubAccountsCard(
          account: sampleAccountItemWithSubs(),
        ),
      ));

      expect(find.text('Jamaica 2027'), findsOneWidget);
      expect(find.text('Emergency Fund'), findsOneWidget);
      expect(find.text('\$100.76'), findsOneWidget);
      expect(find.text('\$500.00'), findsOneWidget);
    });

    testWidgets('highlights selected sub-account', (tester) async {
      await tester.pumpWidget(wrapInApp(
        AccountWithSubAccountsCard(
          account: sampleAccountItemWithSubs(),
          selectedSubAccountId: 'sub-1',
        ),
      ));

      // Find AnimatedContainers (selection bars) - one should be colored
      final bars = tester.widgetList<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final coloredBars = bars.where((bar) {
        final decoration = bar.decoration as BoxDecoration?;
        return decoration?.color != null &&
            decoration!.color != Colors.transparent;
      });
      expect(coloredBars.isNotEmpty, true);
    });

    testWidgets('calls onSubAccountTap with correct SubAccountItem',
        (tester) async {
      SubAccountItem? tappedSub;

      await tester.pumpWidget(wrapInApp(
        AccountWithSubAccountsCard(
          account: sampleAccountItemWithSubs(),
          onSubAccountTap: (sub) => tappedSub = sub,
        ),
      ));

      await tester.tap(find.text('Jamaica 2027'));
      await tester.pump();

      expect(tappedSub, isNotNull);
      expect(tappedSub!.id, 'sub-1');
      expect(tappedSub!.displayName, 'Jamaica 2027');
    });

    testWidgets('disabled parent shows reduced opacity', (tester) async {
      final disabledWithSubs = sampleAccountItem(
        isEnabled: false,
        subItems: const [
          SubAccountItem(id: 'sub-1', displayName: 'Test', balance: 10.0),
        ],
      );

      await tester.pumpWidget(wrapInApp(
        AccountWithSubAccountsCard(account: disabledWithSubs),
      ));

      final opacity = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacity.opacity, 0.4);
    });

    testWidgets('disabled parent does not allow sub-account tap',
        (tester) async {
      SubAccountItem? tappedSub;
      final disabledWithSubs = sampleAccountItem(
        isEnabled: false,
        subItems: const [
          SubAccountItem(id: 'sub-1', displayName: 'Test', balance: 10.0),
        ],
      );

      await tester.pumpWidget(wrapInApp(
        AccountWithSubAccountsCard(
          account: disabledWithSubs,
          onSubAccountTap: (sub) => tappedSub = sub,
        ),
      ));

      await tester.tap(find.text('Test'));
      await tester.pump();

      expect(tappedSub, isNull);
    });

    testWidgets('shows first detail value next to account name',
        (tester) async {
      await tester.pumpWidget(wrapInApp(
        AccountWithSubAccountsCard(
          account: sampleAccountItemWithSubs(),
        ),
      ));

      // First detail value is 'SAVINGS'
      expect(find.text('SAVINGS'), findsOneWidget);
    });
  });
}
