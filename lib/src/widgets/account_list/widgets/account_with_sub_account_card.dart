import 'package:flutter/material.dart';
import '../models/account_item.dart';
import '../models/sub_account_item.dart';
import 'account_card.dart';
import 'sub_account_tile.dart';

class AccountWithSubAccountsCard extends StatelessWidget {
  const AccountWithSubAccountsCard({
    super.key,
    required this.account,

    this.selectedSubAccountId,
    this.onSubAccountTap,
  });

  final AccountItem account;
  final String? selectedSubAccountId;

  final ValueChanged<SubAccountItem>? onSubAccountTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = !account.isEnabled;
    final subItems = account.subItems ?? [];

    return Opacity(
      opacity: isDisabled ? 0.4 : 1.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AccountCard.cardBorderRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                           vertical: 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              account.displayName,
                              style:
                                  theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (account.details.isNotEmpty) ...[
                            const SizedBox(width: 12),
                            Text(
                              account.details.first.value,
                              style:
                                  theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Nested sub-account rows
            Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final sub in subItems)
                    SubAccountTile(
                      item: sub,
                      isSelected: selectedSubAccountId == sub.id,
                      onTap: isDisabled
                          ? null
                          : () => onSubAccountTap?.call(sub),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
