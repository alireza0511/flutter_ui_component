import 'package:flutter/material.dart';
import '../models/account_item.dart';
import '../models/group_item.dart';
import '../widgets/account_selection_content.dart';

Future<AccountItem?> showAccountSelectionModal(
  BuildContext context, {
  required String title,
  required List<GroupItem> groupItems,
  String? subtitle,
  String? selectedAccountId,
  bool showInfoBanner = false,
  String? infoMessage,
}) {
  return Navigator.of(context).push<AccountItem>(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => Scaffold(
        body: SafeArea(
          child: AccountSelectionContent(
            title: title,
            subtitle: subtitle,
            groupItems: groupItems,
            selectedAccountId: selectedAccountId,
            showCloseButton: true,
            onClose: () => Navigator.pop(context),
            onAccountSelected: (account, sub) =>
                Navigator.pop(context, account),
            showInfoBanner: showInfoBanner,
            infoMessage: infoMessage,
          ),
        ),
      ),
    ),
  );
}
