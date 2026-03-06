import 'package:flutter/material.dart';
import 'package:flutter_ui_component/flutter_ui_component.dart';

Widget wrapInApp(Widget child, {ThemeData? theme}) {
  return MaterialApp(
    theme: theme ?? UberTheme.lightTheme,
    home: Scaffold(body: child),
  );
}

Widget wrapInAppWithSize(Widget child, {ThemeData? theme, double height = 600}) {
  return MaterialApp(
    theme: theme ?? UberTheme.lightTheme,
    home: Scaffold(
      body: SizedBox(
        height: height,
        width: 400,
        child: child,
      ),
    ),
  );
}

AccountItem sampleAccountItem({
  String id = 'acc-1',
  String displayName = 'Premier Savings',
  String group = 'CASH',
  bool isEnabled = true,
  List<({String label, String value})>? details,
  List<SubAccountItem>? subItems,
}) {
  return AccountItem(
    id: id,
    displayName: displayName,
    group: group,
    isEnabled: isEnabled,
    details: details ??
        const [
          (label: 'Account Type', value: 'SAVINGS'),
          (label: 'Available Balance', value: '\$87.49'),
        ],
    subItems: subItems,
  );
}

AccountItem sampleAccountItemWithSubs() {
  return sampleAccountItem(
    subItems: [
      const SubAccountItem(
        id: 'sub-1',
        displayName: 'Jamaica 2027',
        balance: 100.76,
      ),
      const SubAccountItem(
        id: 'sub-2',
        displayName: 'Emergency Fund',
        balance: 500.00,
        icon: Icons.savings,
      ),
    ],
  );
}

AccountItem sampleDisabledAccountItem() {
  return sampleAccountItem(
    id: 'acc-disabled',
    displayName: 'Closed Account',
    isEnabled: false,
  );
}

List<GroupItem> sampleGroupItems() {
  return [
    GroupItem(
      label: 'CASH',
      accounts: [
        sampleAccountItem(),
        sampleAccountItem(
          id: 'acc-2',
          displayName: 'Essential Checking',
          details: const [
            (label: 'Account Type', value: 'CHECKING'),
            (label: 'Available Balance', value: '\$2341.56'),
          ],
        ),
      ],
    ),
    GroupItem(
      label: 'CREDIT',
      accounts: [
        sampleAccountItem(
          id: 'acc-3',
          displayName: 'Platinum Rewards Card',
          group: 'CREDIT',
          details: const [
            (label: 'Account Type', value: 'CREDIT_CARD'),
            (label: 'Available Credit', value: '\$8754.11'),
          ],
        ),
      ],
    ),
  ];
}

List<GroupItem> sampleGroupItemsWithSubs() {
  return [
    GroupItem(
      label: 'CASH',
      accounts: [
        sampleAccountItemWithSubs(),
        sampleAccountItem(
          id: 'acc-2',
          displayName: 'Essential Checking',
        ),
      ],
    ),
  ];
}

Map<String, dynamic> sampleAccountJson() {
  return {
    'groups': [
      {
        'accountCategory': 'CASH',
        'accounts': [
          {
            'accountId': 'acc-1',
            'accountStatus': 'OPEN',
            'accountType': 'SAVINGS',
            'accountCategories': ['CASH'],
            'name': 'Premier Savings',
            'nickName': 'Premier Savings',
            'shortNickName': 'SAV4415',
            'availableBalance': '87.49',
            'currentBalance': '0.00',
            'openingBalance': '10.13',
            'principalBalance': '0.00',
            'availableCredit': '0.00',
            'maskedAccountNumber': '*4415',
            'displayName': 'Premier Savings',
            'odOptionsEligible': true,
            'transferToEligible': true,
            'transferFromEligible': true,
            'quickBalanceEligible': true,
            'billPayEligible': false,
            'routingNumber': '044000024',
            'defaultZellePayment': false,
            'account-deposits-envelopes': [
              {
                'accountDepositsEnvelopeId': '678',
                'envelopeName': 'Jamaica 2027',
                'referenceEnvelopecategory': {
                  'referenceEnvelopecategoryId': '5',
                  'envelopecategoryName': 'Vacation',
                  'envelopecategoryType': 'organize',
                },
                'envelopeStatus': 'active',
                'envelopeBalance': '100.76',
                'accountId': '1000002343',
                'quickTipId': '30',
                'envelopeCreatedDate': '2026-01-20',
                'envelopeUpdatedDate': '2026-02-05',
                'account-deposits-envelopes-goals': [
                  {
                    'accountDepositsEnvelopesGoalId': '892',
                    'accountDepositsEnvelopeId': '678',
                    'goalStatus': 'active',
                    'goalTargetAmount': '1500.00',
                    'goalTargetDate': '2027-02-01',
                    'goalCompletionPercentage': '57.24',
                    'goalCreatedDate': '2026-01-20',
                    'goalUpdatedDate': '2026-02-23',
                  },
                ],
              },
            ],
          },
        ],
        'empty': false,
      },
      {
        'accountCategory': 'CREDIT',
        'accounts': [
          {
            'accountId': 'acc-credit',
            'accountStatus': 'OPEN',
            'accountType': 'CREDIT_CARD',
            'accountCategories': ['CREDIT'],
            'name': 'Platinum Rewards Card',
            'nickName': 'Platinum Rewards Card',
            'shortNickName': 'CRD3092',
            'availableBalance': '0.00',
            'currentBalance': '1245.89',
            'openingBalance': '0.00',
            'principalBalance': '1245.89',
            'availableCredit': '8754.11',
            'maskedAccountNumber': '*3092',
            'displayName': 'Platinum Rewards Card',
            'routingNumber': null,
          },
        ],
        'empty': false,
      },
    ],
  };
}
