import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_component/flutter_ui_component.dart';

import '../test_helpers.dart';

void main() {
  group('AccountSelectionScreen', () {
    testWidgets('renders as standalone screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: AccountSelectionScreen(
            title: 'Transfer From',
            subtitle: 'Select an account.',
            groupItems: sampleGroupItems(),
          ),
        ),
      );

      expect(find.text('Transfer From'), findsOneWidget);
      expect(find.text('Select an account.'), findsOneWidget);
      expect(find.text('Premier Savings'), findsOneWidget);
    });

    testWidgets('pops with selected AccountItem', (tester) async {
      AccountItem? result;

      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await Navigator.of(context).push<AccountItem>(
                  MaterialPageRoute(
                    builder: (_) => AccountSelectionScreen(
                      title: 'Title',
                      groupItems: sampleGroupItems(),
                    ),
                  ),
                );
              },
              child: const Text('Go'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Premier Savings'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!.id, 'acc-1');
    });

    testWidgets('handles sub-account selection', (tester) async {
      dynamic result;

      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AccountSelectionScreen(
                      title: 'Title',
                      groupItems: sampleGroupItemsWithSubs(),
                    ),
                  ),
                );
              },
              child: const Text('Go'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Jamaica 2027'));
      await tester.pumpAndSettle();

      // Screen pops with the sub-account item
      expect(result, isNotNull);
    });

    testWidgets('pops with null when close tapped', (tester) async {
      AccountItem? result;
      bool completed = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await Navigator.of(context).push<AccountItem>(
                  MaterialPageRoute(
                    builder: (_) => AccountSelectionScreen(
                      title: 'Title',
                      groupItems: sampleGroupItems(),
                    ),
                  ),
                );
                completed = true;
              },
              child: const Text('Go'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(completed, true);
      expect(result, isNull);
    });

    testWidgets('tracks selection state with pre-selected account',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: AccountSelectionScreen(
            title: 'Title',
            groupItems: sampleGroupItems(),
            selectedAccountId: 'acc-1',
          ),
        ),
      );

      // The selected account card should have higher elevation
      final cards = tester.widgetList<Card>(find.byType(Card));
      expect(cards.any((c) => c.elevation == 2), true);
    });

    testWidgets('shows info banner when enabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: AccountSelectionScreen(
            title: 'Title',
            groupItems: sampleGroupItems(),
            showInfoBanner: true,
            infoMessage: 'Info message',
          ),
        ),
      );

      expect(find.text('Info message'), findsOneWidget);
    });
  });
}
