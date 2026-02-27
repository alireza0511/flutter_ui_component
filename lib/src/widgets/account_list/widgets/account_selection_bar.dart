import 'package:flutter/material.dart';
import 'package:flutter_ui_component/flutter_ui_component.dart';

/// Shared green selection bar used by AccountCard, CompoundAccountCard, and SubAccountRow.
class AccountSelectionBar extends StatelessWidget {
  const AccountSelectionBar({super.key, required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: AccountCard.selectedBarWidth,
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.tertiary
            : Colors.transparent,
      ),
    );
  }
}