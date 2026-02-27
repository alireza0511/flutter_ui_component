import 'package:flutter/material.dart';
import 'package:flutter_ui_component/src/widgets/account_list/widgets/account_selection_bar.dart';
import '../models/account_item.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({
    super.key,
    required this.account,
    this.isSelected = false,
    this.onTap,
  });

  final AccountItem account;
  final bool isSelected;
  final VoidCallback? onTap;

  static const selectedBarWidth = 4.0;
  static const cardBorderRadius = 8.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = !account.isEnabled;

    return Opacity(
      opacity: isDisabled ? 0.4 : 1.0,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: isSelected ? 2 : 1,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(cardBorderRadius),
        //   side: BorderSide(
        //     color: isSelected
        //         ? theme.colorScheme.tertiary
        //         : theme.colorScheme.outline.withValues(alpha: 0.3),
        //     width: isSelected ? 1.5 : 1,
        //   ),
        // ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(cardBorderRadius),
          child: IntrinsicHeight(
            child: Row(
              children: [
                AccountSelectionBar(isSelected: isSelected),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.displayName,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        AccountInfoRow(
                          label: 'Account Type',
                          value: account.typeLabel,
                        ),
                        const SizedBox(height: 4),
                        AccountInfoRow(
                          label: account.balanceLabel,
                          value:
                              '\$${account.balance.toStringAsFixed(2)}',
                        ),
                        if (account.currentBalance != null) ...[
                          const SizedBox(height: 4),
                          AccountInfoRow(
                            label: 'Current Balance',
                            value:
                                '\$${account.currentBalance!.toStringAsFixed(2)}',
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


/// Shared label + value row used inside account cards.
class AccountInfoRow extends StatelessWidget {
  const AccountInfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
