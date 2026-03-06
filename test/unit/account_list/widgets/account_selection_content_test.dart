import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_component/flutter_ui_component.dart';

import '../test_helpers.dart';

void main() {
  group('AccountSelectionContent', () {
    testWidgets('renders header with title and subtitle', (tester) async {
      await tester.pumpWidget(wrapInAppWithSize(
        AccountSelectionContent(
          title: 'Transfer From',
          subtitle: 'Select an account.',
          groupItems: sampleGroupItems(),
        ),
      ));

      expect(find.text('Transfer From'), findsOneWidget);
      expect(find.text('Select an account.'), findsOneWidget);
    });

    testWidgets('renders all groups with headers', (tester) async {
      await tester.pumpWidget(wrapInAppWithSize(
        AccountSelectionContent(
          title: 'Title',
          groupItems: sampleGroupItems(),
        ),
      ));

      expect(find.text('CASH'), findsOneWidget);
      expect(find.text('CREDIT'), findsOneWidget);
    });

    testWidgets('renders accounts within each group', (tester) async {
      await tester.pumpWidget(wrapInAppWithSize(
        AccountSelectionContent(
          title: 'Title',
          groupItems: sampleGroupItems(),
        ),
      ));

      expect(find.text('Premier Savings'), findsOneWidget);
      expect(find.text('Essential Checking'), findsOneWidget);
      expect(find.text('Platinum Rewards Card'), findsOneWidget);
    });

    testWidgets('calls onAccountSelected when account tapped', (tester) async {
      AccountItem? selectedAccount;
      SubAccountItem? selectedSub;

      await tester.pumpWidget(wrapInAppWithSize(
        AccountSelectionContent(
          title: 'Title',
          groupItems: sampleGroupItems(),
          onAccountSelected: (account, sub) {
            selectedAccount = account;
            selectedSub = sub;
          },
        ),
      ));

      await tester.tap(find.text('Premier Savings'));
      await tester.pump();

      expect(selectedAccount, isNotNull);
      expect(selectedAccount!.id, 'acc-1');
      expect(selectedSub, isNull);
    });

    testWidgets('calls onAccountSelected with sub-account when sub tapped',
        (tester) async {
      AccountItem? selectedAccount;
      SubAccountItem? selectedSub;

      await tester.pumpWidget(wrapInAppWithSize(
        AccountSelectionContent(
          title: 'Title',
          groupItems: sampleGroupItemsWithSubs(),
          onAccountSelected: (account, sub) {
            selectedAccount = account;
            selectedSub = sub;
          },
        ),
      ));

      // Tap on the sub-account tile
      await tester.tap(find.text('Jamaica 2027'));
      await tester.pump();

      expect(selectedAccount, isNotNull);
      expect(selectedSub, isNotNull);
      expect(selectedSub!.id, 'sub-1');
    });

    testWidgets('shows info banner when showInfoBanner is true',
        (tester) async {
      await tester.pumpWidget(wrapInAppWithSize(
        AccountSelectionContent(
          title: 'Title',
          groupItems: const [
            GroupItem(label: 'TEST', accounts: []),
          ],
          showInfoBanner: true,
          infoMessage: 'Only eligible accounts.',
        ),
      ));

      expect(find.text('Only eligible accounts.'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('hides info banner when showInfoBanner is false',
        (tester) async {
      await tester.pumpWidget(wrapInAppWithSize(
        AccountSelectionContent(
          title: 'Title',
          groupItems: const [
            GroupItem(label: 'TEST', accounts: []),
          ],
          showInfoBanner: false,
          infoMessage: 'Should not appear',
        ),
      ));

      expect(find.text('Should not appear'), findsNothing);
    });

    testWidgets('shows close button when showCloseButton is true',
        (tester) async {
      await tester.pumpWidget(wrapInAppWithSize(
        AccountSelectionContent(
          title: 'Title',
          groupItems: sampleGroupItems(),
          showCloseButton: true,
        ),
      ));

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('highlights selected account', (tester) async {
      await tester.pumpWidget(wrapInAppWithSize(
        AccountSelectionContent(
          title: 'Title',
          groupItems: sampleGroupItems(),
          selectedAccountId: 'acc-1',
        ),
      ));

      // Find the AccountCard that should be selected
      final cards = tester.widgetList<Card>(find.byType(Card));
      // The selected card should have elevation 2
      expect(cards.any((c) => c.elevation == 2), true);
    });

    testWidgets('uses custom groupHeaderBuilder when provided',
        (tester) async {
      await tester.pumpWidget(wrapInAppWithSize(
        AccountSelectionContent(
          title: 'Title',
          groupItems: sampleGroupItems(),
          groupHeaderBuilder: (label) => Text('Custom: $label'),
        ),
      ));

      expect(find.text('Custom: CASH'), findsOneWidget);
      expect(find.text('Custom: CREDIT'), findsOneWidget);
    });
  });
}
