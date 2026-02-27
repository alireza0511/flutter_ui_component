import 'package:flutter/material.dart';
import '../models/account_item.dart';
import '../widgets/account_selection_content.dart';

class AccountSelectionScreen extends StatefulWidget {
  const AccountSelectionScreen({
    super.key,
    required this.title,
    required this.accounts,
    this.subtitle,
    this.selectedAccountId ,
    this.showInfoBanner = false,
    this.infoMessage,
  });

  final String title;
  final List<AccountItem> accounts;
  final String? subtitle;
  final String? selectedAccountId;
  final bool showInfoBanner;
  final String? infoMessage;

  @override
  State<AccountSelectionScreen> createState() => _AccountSelectionScreenState();
}

class _AccountSelectionScreenState extends State<AccountSelectionScreen> {
  late String? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedAccountId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AccountSelectionContent(
          title: widget.title,
          subtitle: widget.subtitle,
          accounts: widget.accounts,
          selectedAccountId: _selectedId,
          showCloseButton: true,
          onClose: () => Navigator.pop(context),
          onAccountSelected: (account, sub) {
            setState(() => _selectedId = sub?.id ?? account.id);
            Navigator.pop(context, sub ?? account);
          },
         
          showInfoBanner: widget.showInfoBanner,
          infoMessage: widget.infoMessage,
        ),
      ),
    );
  }
}
