import 'sub_account_item.dart';

class AccountItem {
  const AccountItem({
    required this.id,
    required this.displayName,
    required this.group,
    this.details = const [],
    this.subItems,
    this.isEnabled = true,
  });

  final String id;
  final String displayName;
  final String group;
  final List<({String label, String value})> details;
  final List<SubAccountItem>? subItems;
  final bool isEnabled;
}
