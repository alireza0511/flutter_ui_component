import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_component/flutter_ui_component.dart';
import 'package:flutter_ui_component/src/widgets/account_list/widgets/account_selection_bar.dart';

import '../test_helpers.dart';

void main() {
  group('AccountSelectionBar', () {
    testWidgets('shows colored bar when selected', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const SizedBox(
          height: 50,
          child: AccountSelectionBar(isSelected: true),
        ),
      ));

      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, isNot(Colors.transparent));
    });

    testWidgets('transparent when not selected', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const SizedBox(
          height: 50,
          child: AccountSelectionBar(isSelected: false),
        ),
      ));

      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.transparent);
    });

    testWidgets('has correct width matching AccountCard.selectedBarWidth',
        (tester) async {
      await tester.pumpWidget(wrapInApp(
        const IntrinsicHeight(
          child: Row(
            children: [
              AccountSelectionBar(isSelected: true),
              Expanded(child: SizedBox(height: 50)),
            ],
          ),
        ),
      ));
      await tester.pumpAndSettle();

      final barSize = tester.getSize(find.byType(AnimatedContainer));
      expect(barSize.width, AccountCard.selectedBarWidth);
    });

    testWidgets('animates on state change', (tester) async {
      bool selected = false;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return wrapInApp(
              SizedBox(
                height: 50,
                child: GestureDetector(
                  onTap: () => setState(() => selected = !selected),
                  child: AccountSelectionBar(isSelected: selected),
                ),
              ),
            );
          },
        ),
      );

      // Initially transparent
      var container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      var decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.transparent);

      // Tap to toggle
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();
      // Partway through animation
      await tester.pump(const Duration(milliseconds: 100));
      // Animation complete
      await tester.pump(const Duration(milliseconds: 100));

      container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      decoration = container.decoration as BoxDecoration;
      expect(decoration.color, isNot(Colors.transparent));
    });
  });
}
