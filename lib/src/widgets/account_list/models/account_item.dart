import 'account_type.dart';
import 'sub_account_item.dart';

class AccountItem {
  const AccountItem({
    required this.id,
    required this.displayName,
    required this.accountType,
    required this.group,
    required this.balance,
    this.currentBalance,
    this.subItems,
    this.isEnabled = true,
  });

  final String id;
  final String displayName;
  final AccountType accountType;
  final String group;
  final double balance;
  final double? currentBalance;
  final List<SubAccountItem>? subItems;
  final bool isEnabled;

  String get balanceLabel => accountType.balanceLabel;
  String get typeLabel => accountType.label;
}
