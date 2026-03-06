import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_component/flutter_ui_component.dart';

import '../test_helpers.dart';

void main() {
  group('showAccountSelectionModal', () {
    testWidgets('opens full-screen modal with content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showAccountSelectionModal(
                    context,
                    title: 'Transfer From',
                    subtitle: 'Select an account.',
                    groupItems: sampleGroupItems(),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Transfer From'), findsOneWidget);
      expect(find.text('Select an account.'), findsOneWidget);
      expect(find.text('Premier Savings'), findsOneWidget);
    });

    testWidgets('returns selected account on tap', (tester) async {
      AccountItem? result;

      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showAccountSelectionModal(
                    context,
                    title: 'Title',
                    groupItems: sampleGroupItems(),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Premier Savings'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!.id, 'acc-1');
    });

    testWidgets('returns null when close button tapped', (tester) async {
      AccountItem? result;
      bool completed = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showAccountSelectionModal(
                    context,
                    title: 'Title',
                    groupItems: sampleGroupItems(),
                  );
                  completed = true;
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(completed, true);
      expect(result, isNull);
    });

    testWidgets('shows info banner when enabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showAccountSelectionModal(
                    context,
                    title: 'Title',
                    groupItems: sampleGroupItems(),
                    showInfoBanner: true,
                    infoMessage: 'Only eligible accounts.',
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Only eligible accounts.'), findsOneWidget);
    });
  });
}
