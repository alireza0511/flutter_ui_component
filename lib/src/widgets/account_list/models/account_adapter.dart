import 'account_item.dart';
import 'account_response.dart';
import 'group_item.dart';
import 'sub_account_item.dart';

class AccountAdapter {
  const AccountAdapter._();

  static GroupItem fromAccountGroup(AccountGroup group) {
    return GroupItem(
      label: group.accountCategory,
      accounts: group.accounts.map(_fromAccount).toList(),
    );
  }

  static List<GroupItem> fromAccountGroups(List<AccountGroup> groups) {
    return groups.map(fromAccountGroup).toList();
  }

  static AccountItem _fromAccount(Account account) {
    return AccountItem(
      id: account.accountId,
      displayName: account.displayName,
      group: account.accountCategories.firstOrNull ?? '',
      details: _buildDetails(account),
      subItems: account.envelopes.isNotEmpty
          ? account.envelopes.map(_fromEnvelope).toList()
          : null,
      isEnabled: account.accountStatus == 'OPEN',
    );
  }

  static List<({String label, String value})> _buildDetails(Account account) {
    final details = <({String label, String value})>[];

    details.add((label: 'Account Type', value: account.accountType));

    final availableBalance = double.tryParse(account.availableBalance);
    if (availableBalance != null && availableBalance > 0) {
      details.add((
        label: 'Available Balance',
        value: '\$${account.availableBalance}',
      ));
    }

    final currentBalance = double.tryParse(account.currentBalance);
    if (currentBalance != null && currentBalance > 0) {
      details.add((
        label: 'Current Balance',
        value: '\$${account.currentBalance}',
      ));
    }

    final availableCredit = double.tryParse(account.availableCredit);
    if (availableCredit != null && availableCredit > 0) {
      details.add((
        label: 'Available Credit',
        value: '\$${account.availableCredit}',
      ));
    }

    return details;
  }

  static SubAccountItem _fromEnvelope(Envelope envelope) {
    return SubAccountItem(
      id: envelope.envelopeId,
      displayName: envelope.envelopeName,
      balance: double.tryParse(envelope.envelopeBalance) ?? 0.0,
    );
  }
}
