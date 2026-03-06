import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_component/flutter_ui_component.dart';

import '../test_helpers.dart';

void main() {
  group('SubAccountTile', () {
    const subItem = SubAccountItem(
      id: 'sub-1',
      displayName: 'Jamaica 2027',
      balance: 100.76,
    );

    testWidgets('renders name and formatted balance', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const SubAccountTile(item: subItem),
      ));

      expect(find.text('Jamaica 2027'), findsOneWidget);
      expect(find.text('\$100.76'), findsOneWidget);
    });

    testWidgets('shows selection bar when selected', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const SubAccountTile(item: subItem, isSelected: true),
      ));

      final bar = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = bar.decoration as BoxDecoration;
      expect(decoration.color, isNot(Colors.transparent));
    });

    testWidgets('selection bar transparent when not selected', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const SubAccountTile(item: subItem, isSelected: false),
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
        SubAccountTile(
          item: subItem,
          onTap: () => tapped = true,
        ),
      ));

      await tester.tap(find.byType(InkWell));
      expect(tapped, true);
    });

    testWidgets('renders icon when provided', (tester) async {
      const subWithIcon = SubAccountItem(
        id: 'sub-icon',
        displayName: 'Emergency Fund',
        balance: 500.00,
        icon: Icons.savings,
      );

      await tester.pumpWidget(wrapInApp(
        const SubAccountTile(item: subWithIcon),
      ));

      expect(find.byIcon(Icons.savings), findsOneWidget);
    });

    testWidgets('does not render icon when null', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const SubAccountTile(item: subItem),
      ));

      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('selected tile has higher elevation', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const SubAccountTile(item: subItem, isSelected: true),
      ));

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 2);
    });
  });
}
