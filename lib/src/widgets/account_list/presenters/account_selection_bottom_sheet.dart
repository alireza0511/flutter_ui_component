import 'package:flutter/material.dart';
import '../models/account_item.dart';
import '../widgets/account_selection_content.dart';

Future<AccountItem?> showAccountSelectionBottomSheet(
  BuildContext context, {
  required String title,
  required List<AccountItem> accounts,
  String? subtitle,
  String? selectedAccountId,
  bool showInfoBanner = false,
  String? infoMessage,
  double initialChildSize = 0.6,
  double maxChildSize = 0.95,
}) {
  return showModalBottomSheet<AccountItem>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: initialChildSize,
      maxChildSize: maxChildSize,
      minChildSize: 0.3,
      expand: false,
      builder: (context, scrollController) => AccountSelectionContent(
        title: title,
        subtitle: subtitle,
        accounts: accounts,
        selectedAccountId: selectedAccountId,
        showCloseButton: true,
        onClose: () => Navigator.pop(context),
        onAccountSelected: (account, sub) => Navigator.pop(context, account),
        showInfoBanner: showInfoBanner,
        infoMessage: infoMessage,
        scrollController: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    ),
  );
}
