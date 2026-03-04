import 'account_item.dart';

class GroupItem {
  const GroupItem({
    required this.label,
    required this.accounts,
  });

  final String label;
  final List<AccountItem> accounts;
}
