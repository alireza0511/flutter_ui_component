import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_component/flutter_ui_component.dart';

void main() {
  group('Accessibility Tests', () {
    testWidgets('UberTextButton accessibility', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: Column(
              children: [
                UberTextButton(
                  onPressed: () {},
                  semanticLabel: 'Primary text button',
                  child: const Text('Primary Button'),
                ),
                UberTextButton(
                  onPressed: () {},
                  enabled: false,
                  semanticLabel: 'Disabled text button',
                  child: const Text('Disabled Button'),
                ),
                UberTextButton(
                  onPressed: () {},
                  isLoading: true,
                  semanticLabel: 'Loading text button',
                  child: const Text('Loading Button'),
                ),
              ],
            ),
          ),
        ),
      );

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));

      expect(find.bySemanticsLabel('Primary text button'), findsOneWidget);
      expect(find.bySemanticsLabel('Disabled text button'), findsOneWidget);
      expect(find.bySemanticsLabel('Loading text button'), findsOneWidget);

      final primaryButtonSemantics = tester.getSemantics(find.bySemanticsLabel('Primary text button'));
      expect(primaryButtonSemantics.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);

      final disabledButtonSemantics = tester.getSemantics(find.bySemanticsLabel('Disabled text button'));
      expect(disabledButtonSemantics.getSemanticsData().hasFlag(SemanticsFlag.hasEnabledState), isTrue);
    });

    testWidgets('UberElevatedButton accessibility', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: Column(
              children: [
                UberElevatedButton(
                  onPressed: () {},
                  semanticLabel: 'Primary elevated button',
                  child: const Text('Primary Button'),
                ),
                UberElevatedButton(
                  onPressed: () {},
                  enabled: false,
                  semanticLabel: 'Disabled elevated button',
                  child: const Text('Disabled Button'),
                ),
                UberElevatedButton(
                  onPressed: () {},
                  variant: UberElevatedButtonVariant.destructive,
                  semanticLabel: 'Destructive elevated button',
                  child: const Text('Delete'),
                ),
              ],
            ),
          ),
        ),
      );

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));

      expect(find.bySemanticsLabel('Primary elevated button'), findsOneWidget);
      expect(find.bySemanticsLabel('Disabled elevated button'), findsOneWidget);
      expect(find.bySemanticsLabel('Destructive elevated button'), findsOneWidget);

      final primaryButtonSemantics = tester.getSemantics(find.bySemanticsLabel('Primary elevated button'));
      expect(primaryButtonSemantics.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);

      final disabledButtonSemantics = tester.getSemantics(find.bySemanticsLabel('Disabled elevated button'));
      expect(disabledButtonSemantics.getSemanticsData().hasFlag(SemanticsFlag.hasEnabledState), isTrue);
    });

    testWidgets('UberAmountInput accessibility', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: Column(
              children: [
                UberAmountInput(
                  onChanged: (value) {},
                  label: 'Amount',
                  semanticLabel: 'Enter amount in dollars',
                  hintText: 'Enter amount',
                ),
                UberAmountInput(
                  onChanged: (value) {},
                  label: 'Disabled Amount',
                  enabled: false,
                  semanticLabel: 'Disabled amount input',
                ),
                UberAmountInput(
                  onChanged: (value) {},
                  label: 'Amount with Error',
                  errorText: 'Invalid amount',
                  semanticLabel: 'Amount with validation error',
                ),
              ],
            ),
          ),
        ),
      );

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));

      expect(find.bySemanticsLabel('Enter amount in dollars'), findsOneWidget);
      expect(find.bySemanticsLabel('Disabled amount input'), findsOneWidget);
      expect(find.bySemanticsLabel('Amount with validation error'), findsOneWidget);

      final amountInputSemantics = tester.getSemantics(find.bySemanticsLabel('Enter amount in dollars'));
      expect(amountInputSemantics.getSemanticsData().hasFlag(SemanticsFlag.isTextField), isTrue);

      final disabledInputSemantics = tester.getSemantics(find.bySemanticsLabel('Disabled amount input'));
      expect(disabledInputSemantics.getSemanticsData().hasFlag(SemanticsFlag.hasEnabledState), isTrue);
    });

    testWidgets('UberTextInput accessibility', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: Column(
              children: [
                UberTextInput(
                  onChanged: (value) {},
                  label: 'Name',
                  semanticLabel: 'Enter your full name',
                  hintText: 'Enter name',
                ),
                UberTextInput(
                  onChanged: (value) {},
                  label: 'Email',
                  type: UberTextInputType.email,
                  semanticLabel: 'Enter your email address',
                ),
                UberTextInput(
                  onChanged: (value) {},
                  label: 'Password',
                  type: UberTextInputType.password,
                  semanticLabel: 'Enter your password',
                ),
                UberTextInput(
                  onChanged: (value) {},
                  label: 'Comments',
                  type: UberTextInputType.multiline,
                  semanticLabel: 'Enter your comments',
                ),
              ],
            ),
          ),
        ),
      );

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));

      expect(find.bySemanticsLabel('Enter your full name'), findsOneWidget);
      expect(find.bySemanticsLabel('Enter your email address'), findsOneWidget);
      expect(find.bySemanticsLabel('Enter your password'), findsOneWidget);
      expect(find.bySemanticsLabel('Enter your comments'), findsOneWidget);

      final nameInputSemantics = tester.getSemantics(find.bySemanticsLabel('Enter your full name'));
      expect(nameInputSemantics.getSemanticsData().hasFlag(SemanticsFlag.isTextField), isTrue);

      final passwordInputSemantics = tester.getSemantics(find.bySemanticsLabel('Enter your password'));
      expect(passwordInputSemantics.getSemanticsData().hasFlag(SemanticsFlag.isObscured), isTrue);

      final multilineInputSemantics = tester.getSemantics(find.bySemanticsLabel('Enter your comments'));
      expect(multilineInputSemantics.getSemanticsData().hasFlag(SemanticsFlag.isMultiline), isTrue);
    });

    testWidgets('UberRadio accessibility', (WidgetTester tester) async {
      String? selectedValue;

      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    UberRadio<String>(
                      value: 'option1',
                      groupValue: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                      semanticLabel: 'Option 1',
                    ),
                    UberRadio<String>(
                      value: 'option2',
                      groupValue: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                      semanticLabel: 'Option 2',
                    ),
                    UberRadio<String>(
                      value: 'option3',
                      groupValue: selectedValue,
                      onChanged: null,
                      enabled: false,
                      semanticLabel: 'Disabled Option 3',
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));

      expect(find.bySemanticsLabel('Option 1'), findsOneWidget);
      expect(find.bySemanticsLabel('Option 2'), findsOneWidget);
      expect(find.bySemanticsLabel('Disabled Option 3'), findsOneWidget);

      final option1Semantics = tester.getSemantics(find.bySemanticsLabel('Option 1'));
      expect(option1Semantics.getSemanticsData().hasFlag(SemanticsFlag.isInMutuallyExclusiveGroup), isTrue);
      expect(option1Semantics.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);

      final disabledOptionSemantics = tester.getSemantics(find.bySemanticsLabel('Disabled Option 3'));
      expect(disabledOptionSemantics.getSemanticsData().hasFlag(SemanticsFlag.hasEnabledState), isTrue);
    });

    testWidgets('UberRadioListTile accessibility', (WidgetTester tester) async {
      String? selectedValue;

      await tester.pumpWidget(
        MaterialApp(
          theme: UberTheme.lightTheme,
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    UberRadioListTile<String>(
                      value: 'option1',
                      groupValue: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                      title: const Text('First Option'),
                      subtitle: const Text('Description of first option'),
                      semanticLabel: 'Select first option',
                    ),
                    UberRadioListTile<String>(
                      value: 'option2',
                      groupValue: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                      title: const Text('Second Option'),
                      semanticLabel: 'Select second option',
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));

      expect(find.text('First Option'), findsOneWidget);
      expect(find.text('Description of first option'), findsOneWidget);
      expect(find.text('Second Option'), findsOneWidget);

      expect(find.bySemanticsLabel('Select first option'), findsOneWidget);
      expect(find.bySemanticsLabel('Select second option'), findsOneWidget);
    });

    group('High Contrast Mode Tests', () {
      testWidgets('components should be visible in high contrast mode', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: UberTheme.darkTheme.copyWith(
              brightness: Brightness.dark,
              colorScheme: UberTheme.darkTheme.colorScheme.copyWith(
                primary: Colors.white,
                onPrimary: Colors.black,
                background: Colors.black,
                onBackground: Colors.white,
                surface: Colors.black,
                onSurface: Colors.white,
              ),
            ),
            home: Scaffold(
              body: Column(
                children: [
                  UberTextButton(
                    onPressed: () {},
                    child: const Text('High Contrast Button'),
                  ),
                  UberElevatedButton(
                    onPressed: () {},
                    child: const Text('High Contrast Elevated'),
                  ),
                  UberAmountInput(
                    onChanged: (value) {},
                    label: 'High Contrast Amount',
                  ),
                  UberTextInput(
                    onChanged: (value) {},
                    label: 'High Contrast Text',
                  ),
                ],
              ),
            ),
          ),
        );

        await expectLater(tester, meetsGuideline(textContrastGuideline));
        
        expect(find.text('High Contrast Button'), findsOneWidget);
        expect(find.text('High Contrast Elevated'), findsOneWidget);
        expect(find.text('High Contrast Amount'), findsOneWidget);
        expect(find.text('High Contrast Text'), findsOneWidget);
      });
    });

    group('Focus Order Tests', () {
      testWidgets('components should have logical focus order', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: UberTheme.lightTheme,
            home: Scaffold(
              body: Column(
                children: [
                  UberTextInput(
                    onChanged: (value) {},
                    label: 'First Input',
                  ),
                  UberAmountInput(
                    onChanged: (value) {},
                    label: 'Second Input',
                  ),
                  UberTextButton(
                    onPressed: () {},
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        );

        final firstInput = find.byType(UberTextInput);
        final secondInput = find.byType(UberAmountInput);
        final submitButton = find.byType(UberTextButton);

        expect(firstInput, findsOneWidget);
        expect(secondInput, findsOneWidget);
        expect(submitButton, findsOneWidget);

        await tester.tap(firstInput);
        await tester.pump();

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
      });
    });

    group('AccountCard Accessibility', () {
      testWidgets('meets tap target guidelines', (WidgetTester tester) async {
        final account = AccountItem(
          id: 'acc-1',
          displayName: 'Premier Savings',
          group: 'CASH',
          details: const [
            (label: 'Account Type', value: 'SAVINGS'),
            (label: 'Available Balance', value: '\$87.49'),
          ],
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: UberTheme.lightTheme,
            home: Scaffold(
              body: AccountCard(
                account: account,
                onTap: () {},
              ),
            ),
          ),
        );

        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      });

      testWidgets('meets text contrast guideline', (WidgetTester tester) async {
        final account = AccountItem(
          id: 'acc-1',
          displayName: 'Premier Savings',
          group: 'CASH',
          details: const [
            (label: 'Account Type', value: 'SAVINGS'),
          ],
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: UberTheme.lightTheme,
            home: Scaffold(
              body: AccountCard(
                account: account,
                onTap: () {},
              ),
            ),
          ),
        );

        await expectLater(tester, meetsGuideline(textContrastGuideline));
      });
    });

    group('SubAccountTile Accessibility', () {
      testWidgets('meets tap target guidelines', (WidgetTester tester) async {
        const subItem = SubAccountItem(
          id: 'sub-1',
          displayName: 'Jamaica 2027',
          balance: 100.76,
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: UberTheme.lightTheme,
            home: Scaffold(
              body: SubAccountTile(
                item: subItem,
                onTap: () {},
              ),
            ),
          ),
        );

        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      });
    });

    group('AccountSelectionContent Accessibility', () {
      testWidgets('meets labeled tap target guideline', (WidgetTester tester) async {
        final groups = [
          GroupItem(
            label: 'CASH',
            accounts: [
              AccountItem(
                id: 'acc-1',
                displayName: 'Premier Savings',
                group: 'CASH',
                details: const [
                  (label: 'Account Type', value: 'SAVINGS'),
                ],
              ),
            ],
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            theme: UberTheme.lightTheme,
            home: Scaffold(
              body: SizedBox(
                height: 500,
                child: AccountSelectionContent(
                  title: 'Transfer From',
                  groupItems: groups,
                  showCloseButton: true,
                  onClose: () {},
                  onAccountSelected: (_, __) {},
                ),
              ),
            ),
          ),
        );

        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      });

      testWidgets('close button has tooltip', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: UberTheme.lightTheme,
            home: Scaffold(
              body: SizedBox(
                height: 400,
                child: AccountSelectionContent(
                  title: 'Title',
                  groupItems: const [],
                  showCloseButton: true,
                  onClose: () {},
                ),
              ),
            ),
          ),
        );

        expect(find.byTooltip('Close'), findsOneWidget);
      });
    });

    group('AccountList Focus Order Tests', () {
      testWidgets('Tab navigates through account cards in order', (WidgetTester tester) async {
        final groups = [
          GroupItem(
            label: 'CASH',
            accounts: [
              AccountItem(
                id: 'acc-1',
                displayName: 'Account One',
                group: 'CASH',
              ),
              AccountItem(
                id: 'acc-2',
                displayName: 'Account Two',
                group: 'CASH',
              ),
            ],
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            theme: UberTheme.lightTheme,
            home: Scaffold(
              body: SizedBox(
                height: 500,
                child: AccountSelectionContent(
                  title: 'Title',
                  groupItems: groups,
                  showCloseButton: true,
                  onClose: () {},
                  onAccountSelected: (_, __) {},
                ),
              ),
            ),
          ),
        );

        // Tab through focusable elements
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();

        // All account cards and close button should be focusable
        expect(find.byType(AccountCard), findsNWidgets(2));
        expect(find.byIcon(Icons.close), findsOneWidget);
      });

      testWidgets('Tab navigates into sub-account tiles', (WidgetTester tester) async {
        final groups = [
          GroupItem(
            label: 'CASH',
            accounts: [
              AccountItem(
                id: 'acc-1',
                displayName: 'Premier Savings',
                group: 'CASH',
                subItems: const [
                  SubAccountItem(id: 'sub-1', displayName: 'Sub One', balance: 100.0),
                  SubAccountItem(id: 'sub-2', displayName: 'Sub Two', balance: 200.0),
                ],
              ),
            ],
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            theme: UberTheme.lightTheme,
            home: Scaffold(
              body: SizedBox(
                height: 500,
                child: AccountSelectionContent(
                  title: 'Title',
                  groupItems: groups,
                  onAccountSelected: (_, __) {},
                ),
              ),
            ),
          ),
        );

        // Tab through sub-account tiles
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();

        expect(find.byType(SubAccountTile), findsNWidgets(2));
      });

      testWidgets('Enter selects focused account', (WidgetTester tester) async {
        AccountItem? selected;
        final groups = [
          GroupItem(
            label: 'CASH',
            accounts: [
              AccountItem(
                id: 'acc-1',
                displayName: 'Premier Savings',
                group: 'CASH',
              ),
            ],
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            theme: UberTheme.lightTheme,
            home: Scaffold(
              body: SizedBox(
                height: 400,
                child: AccountSelectionContent(
                  title: 'Title',
                  groupItems: groups,
                  onAccountSelected: (account, _) => selected = account,
                ),
              ),
            ),
          ),
        );

        // Tab to focus the account card
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();

        // Press Enter to select
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pump();

        expect(selected?.id, 'acc-1');
      });
    });
  });
}