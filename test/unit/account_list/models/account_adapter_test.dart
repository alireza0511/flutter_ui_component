import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_component/flutter_ui_component.dart';

import '../test_helpers.dart';

void main() {
  group('AccountAdapter', () {
    group('fromAccountGroups', () {
      test('converts list of AccountGroup to List<GroupItem>', () {
        final json = sampleAccountJson();
        final response = AccountResponse.fromJson(json);
        final groups = AccountAdapter.fromAccountGroups(response.groups);

        expect(groups, hasLength(2));
        expect(groups[0].label, 'CASH');
        expect(groups[1].label, 'CREDIT');
      });
    });

    group('fromAccountGroup', () {
      test('maps accountCategory to GroupItem.label', () {
        final group = AccountGroup.fromJson(
          (sampleAccountJson()['groups'] as List).first
              as Map<String, dynamic>,
        );
        final groupItem = AccountAdapter.fromAccountGroup(group);

        expect(groupItem.label, 'CASH');
        expect(groupItem.accounts, hasLength(1));
      });

      test('maps account fields correctly', () {
        final json = sampleAccountJson();
        final response = AccountResponse.fromJson(json);
        final groups = AccountAdapter.fromAccountGroups(response.groups);
        final account = groups[0].accounts[0];

        expect(account.id, 'acc-1');
        expect(account.displayName, 'Premier Savings');
        expect(account.group, 'CASH');
        expect(account.isEnabled, true);
      });

      test('sets isEnabled to false when accountStatus is not OPEN', () {
        final json = {
          'accountCategory': 'CASH',
          'accounts': [
            {
              'accountId': 'closed-1',
              'accountStatus': 'CLOSED',
              'accountType': 'SAVINGS',
              'accountCategories': ['CASH'],
              'name': 'Closed',
              'nickName': 'Closed',
              'shortNickName': 'SAV0000',
              'availableBalance': '0.00',
              'currentBalance': '0.00',
              'openingBalance': '0.00',
              'principalBalance': '0.00',
              'availableCredit': '0.00',
              'maskedAccountNumber': '*0000',
              'displayName': 'Closed Account',
            },
          ],
          'empty': false,
        };
        final group = AccountGroup.fromJson(json);
        final groupItem = AccountAdapter.fromAccountGroup(group);

        expect(groupItem.accounts[0].isEnabled, false);
      });
    });

    group('details building', () {
      test('includes only positive balances in details', () {
        final json = sampleAccountJson();
        final response = AccountResponse.fromJson(json);
        final groups = AccountAdapter.fromAccountGroups(response.groups);
        final account = groups[0].accounts[0];

        // Account Type is always included
        expect(account.details.any((d) => d.label == 'Account Type'), true);
        // Available Balance 87.49 > 0, so included
        expect(
            account.details.any((d) => d.label == 'Available Balance'), true);
        // Current Balance 0.00, so NOT included
        expect(
            account.details.any((d) => d.label == 'Current Balance'), false);
      });

      test('includes available credit when > 0', () {
        final json = sampleAccountJson();
        final response = AccountResponse.fromJson(json);
        final groups = AccountAdapter.fromAccountGroups(response.groups);
        final creditAccount = groups[1].accounts[0];

        expect(
          creditAccount.details.any((d) => d.label == 'Available Credit'),
          true,
        );
      });

      test('formats balance values with dollar sign', () {
        final json = sampleAccountJson();
        final response = AccountResponse.fromJson(json);
        final groups = AccountAdapter.fromAccountGroups(response.groups);
        final account = groups[0].accounts[0];

        final balanceDetail =
            account.details.firstWhere((d) => d.label == 'Available Balance');
        expect(balanceDetail.value, '\$87.49');
      });
    });

    group('envelope mapping', () {
      test('maps envelopes to SubAccountItem', () {
        final json = sampleAccountJson();
        final response = AccountResponse.fromJson(json);
        final groups = AccountAdapter.fromAccountGroups(response.groups);
        final account = groups[0].accounts[0];

        expect(account.subItems, isNotNull);
        expect(account.subItems, hasLength(1));
        expect(account.subItems![0].id, '678');
        expect(account.subItems![0].displayName, 'Jamaica 2027');
        expect(account.subItems![0].balance, 100.76);
      });

      test('empty envelopes result in null subItems', () {
        final json = sampleAccountJson();
        final response = AccountResponse.fromJson(json);
        final groups = AccountAdapter.fromAccountGroups(response.groups);
        final creditAccount = groups[1].accounts[0];

        expect(creditAccount.subItems, isNull);
      });
    });
  });
}
