import 'package:flutter/material.dart';
import '../models/account_item.dart';
import '../models/group_item.dart';
import '../models/sub_account_item.dart';
import 'account_card.dart';
import 'account_group_header.dart';
import 'account_selection_header.dart';
import 'account_with_sub_account_card.dart';
import 'info_banner.dart';

class AccountSelectionContent extends StatelessWidget {
  const AccountSelectionContent({
    super.key,
    required this.title,
    required this.groupItems,
    this.subtitle,
    this.selectedAccountId,
    this.onAccountSelected,
    this.groupHeaderBuilder,
    this.showCloseButton = false,
    this.onClose,
    this.showInfoBanner = false,
    this.infoMessage,
    this.padding,
    this.scrollController,
  });

  final String title;
  final String? subtitle;
  final List<GroupItem> groupItems;
  final String? selectedAccountId;
  final void Function(AccountItem account, SubAccountItem? subAccount)?
      onAccountSelected;
  final Widget Function(String group)? groupHeaderBuilder;
  final bool showCloseButton;
  final VoidCallback? onClose;
  final bool showInfoBanner;
  final String? infoMessage;
  final EdgeInsets? padding;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final effectivePadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 16);
    final items = _buildItemList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: effectivePadding,
          child: AccountSelectionHeader(
            title: title,
            subtitle: subtitle,
            showCloseButton: showCloseButton,
            onClose: onClose,
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            padding: effectivePadding.copyWith(top: 0, bottom: 16),
            itemCount: items.length,
            itemBuilder: (context, index) => items[index],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildItemList() {
    final items = <Widget>[];

    for (final group in groupItems) {
      items.add(
        groupHeaderBuilder?.call(group.label) ??
            AccountGroupHeader(label: group.label),
      );

      for (final account in group.accounts) {
        final hasSubItems =
            account.subItems != null && account.subItems!.isNotEmpty;

        items.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: hasSubItems
                ? AccountWithSubAccountsCard(
                    account: account,
                    selectedSubAccountId: selectedAccountId,
                    onSubAccountTap: (sub) =>
                        onAccountSelected?.call(account, sub),
                  )
                : AccountCard(
                    account: account,
                    isSelected: selectedAccountId == account.id,
                    onTap: () => onAccountSelected?.call(account, null),
                  ),
          ),
        );
      }
    }

    if (showInfoBanner && infoMessage != null) {
      items.add(
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: InfoBanner(message: infoMessage!),
        ),
      );
    }

    return items;
  }
}
