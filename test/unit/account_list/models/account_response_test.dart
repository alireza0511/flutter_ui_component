import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_component/flutter_ui_component.dart';

import '../test_helpers.dart';

void main() {
  group('AccountResponse', () {
    test('fromJson parses groups correctly', () {
      final json = sampleAccountJson();
      final response = AccountResponse.fromJson(json);

      expect(response.groups, hasLength(2));
      expect(response.groups[0].accountCategory, 'CASH');
      expect(response.groups[1].accountCategory, 'CREDIT');
    });
  });

  group('AccountGroup', () {
    test('fromJson parses accountCategory and accounts', () {
      final json = (sampleAccountJson()['groups'] as List).first
          as Map<String, dynamic>;
      final group = AccountGroup.fromJson(json);

      expect(group.accountCategory, 'CASH');
      expect(group.accounts, hasLength(1));
      expect(group.empty, false);
    });

    test('fromJson defaults empty to false when missing', () {
      final json = {
        'accountCategory': 'TEST',
        'accounts': <dynamic>[],
      };
      final group = AccountGroup.fromJson(json);
      expect(group.empty, false);
    });
  });

  group('Account', () {
    late Account account;

    setUp(() {
      final json = ((sampleAccountJson()['groups'] as List).first
          as Map<String, dynamic>)['accounts'][0] as Map<String, dynamic>;
      account = Account.fromJson(json);
    });

    test('fromJson parses basic fields', () {
      expect(account.accountId, 'acc-1');
      expect(account.accountStatus, 'OPEN');
      expect(account.accountType, 'SAVINGS');
      expect(account.displayName, 'Premier Savings');
      expect(account.name, 'Premier Savings');
      expect(account.nickName, 'Premier Savings');
      expect(account.shortNickName, 'SAV4415');
      expect(account.maskedAccountNumber, '*4415');
    });

    test('fromJson parses accountCategories', () {
      expect(account.accountCategories, ['CASH']);
    });

    test('fromJson parses balance fields', () {
      expect(account.availableBalance, '87.49');
      expect(account.currentBalance, '0.00');
      expect(account.openingBalance, '10.13');
      expect(account.principalBalance, '0.00');
      expect(account.availableCredit, '0.00');
    });

    test('fromJson parses boolean flags', () {
      expect(account.odOptionsEligible, true);
      expect(account.transferToEligible, true);
      expect(account.transferFromEligible, true);
      expect(account.quickBalanceEligible, true);
      expect(account.billPayEligible, false);
      expect(account.defaultZellePayment, false);
    });

    test('fromJson parses routingNumber', () {
      expect(account.routingNumber, '044000024');
    });

    test('fromJson handles null routingNumber', () {
      final json = ((sampleAccountJson()['groups'] as List)[1]
          as Map<String, dynamic>)['accounts'][0] as Map<String, dynamic>;
      final creditAccount = Account.fromJson(json);
      expect(creditAccount.routingNumber, isNull);
    });

    test('fromJson parses envelopes', () {
      expect(account.envelopes, hasLength(1));
      expect(account.envelopes.first.envelopeName, 'Jamaica 2027');
    });

    test('fromJson defaults envelopes to empty list when missing', () {
      final json = ((sampleAccountJson()['groups'] as List)[1]
          as Map<String, dynamic>)['accounts'][0] as Map<String, dynamic>;
      final creditAccount = Account.fromJson(json);
      expect(creditAccount.envelopes, isEmpty);
    });
  });

  group('Envelope', () {
    late Envelope envelope;

    setUp(() {
      final accountJson = ((sampleAccountJson()['groups'] as List).first
          as Map<String, dynamic>)['accounts'][0] as Map<String, dynamic>;
      final envelopeJson =
          (accountJson['account-deposits-envelopes'] as List).first
              as Map<String, dynamic>;
      envelope = Envelope.fromJson(envelopeJson);
    });

    test('fromJson parses basic fields', () {
      expect(envelope.envelopeId, '678');
      expect(envelope.envelopeName, 'Jamaica 2027');
      expect(envelope.envelopeStatus, 'active');
      expect(envelope.envelopeBalance, '100.76');
      expect(envelope.accountId, '1000002343');
      expect(envelope.quickTipId, '30');
      expect(envelope.envelopeCreatedDate, '2026-01-20');
      expect(envelope.envelopeUpdatedDate, '2026-02-05');
    });

    test('fromJson parses category', () {
      expect(envelope.category, isNotNull);
      expect(envelope.category!.id, '5');
      expect(envelope.category!.name, 'Vacation');
      expect(envelope.category!.type, 'organize');
    });

    test('fromJson parses goals', () {
      expect(envelope.goals, hasLength(1));
    });
  });

  group('EnvelopeGoal', () {
    test('fromJson parses all fields', () {
      final json = {
        'accountDepositsEnvelopesGoalId': '892',
        'accountDepositsEnvelopeId': '678',
        'goalStatus': 'active',
        'goalTargetAmount': '1500.00',
        'goalTargetDate': '2027-02-01',
        'goalCompletionPercentage': '57.24',
        'goalCreatedDate': '2026-01-20',
        'goalUpdatedDate': '2026-02-23',
      };
      final goal = EnvelopeGoal.fromJson(json);

      expect(goal.goalId, '892');
      expect(goal.envelopeId, '678');
      expect(goal.goalStatus, 'active');
      expect(goal.targetAmount, '1500.00');
      expect(goal.targetDate, '2027-02-01');
      expect(goal.completionPercentage, '57.24');
      expect(goal.goalCreatedDate, '2026-01-20');
      expect(goal.goalUpdatedDate, '2026-02-23');
    });

    test('fromJson handles null date fields', () {
      final json = {
        'accountDepositsEnvelopesGoalId': '1',
        'accountDepositsEnvelopeId': '2',
        'goalStatus': 'active',
        'goalTargetAmount': '100.00',
        'goalTargetDate': '2027-01-01',
        'goalCompletionPercentage': '0.00',
      };
      final goal = EnvelopeGoal.fromJson(json);

      expect(goal.goalCreatedDate, isNull);
      expect(goal.goalUpdatedDate, isNull);
    });
  });

  group('EnvelopeCategory', () {
    test('fromJson parses all fields', () {
      final json = {
        'referenceEnvelopecategoryId': '5',
        'envelopecategoryName': 'Vacation',
        'envelopecategoryType': 'organize',
      };
      final category = EnvelopeCategory.fromJson(json);

      expect(category.id, '5');
      expect(category.name, 'Vacation');
      expect(category.type, 'organize');
    });
  });
}
