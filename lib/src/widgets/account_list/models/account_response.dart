class AccountResponse {
  const AccountResponse({required this.groups});

  final List<AccountGroup> groups;

  factory AccountResponse.fromJson(Map<String, dynamic> json) {
    return AccountResponse(
      groups: (json['groups'] as List<dynamic>)
          .map((e) => AccountGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class AccountGroup {
  const AccountGroup({
    required this.accountCategory,
    required this.accounts,
    this.empty = false,
  });

  final String accountCategory;
  final List<Account> accounts;
  final bool empty;

  factory AccountGroup.fromJson(Map<String, dynamic> json) {
    return AccountGroup(
      accountCategory: json['accountCategory'] as String,
      accounts: (json['accounts'] as List<dynamic>)
          .map((e) => Account.fromJson(e as Map<String, dynamic>))
          .toList(),
      empty: json['empty'] as bool? ?? false,
    );
  }
}

class Account {
  const Account({
    required this.accountId,
    required this.accountStatus,
    required this.accountType,
    required this.accountCategories,
    required this.name,
    required this.nickName,
    required this.shortNickName,
    required this.availableBalance,
    required this.currentBalance,
    required this.openingBalance,
    required this.principalBalance,
    required this.availableCredit,
    required this.maskedAccountNumber,
    required this.displayName,
    this.odOptionsEligible = false,
    this.transferToEligible = false,
    this.transferFromEligible = false,
    this.quickBalanceEligible = false,
    this.billPayEligible = false,
    this.routingNumber,
    this.defaultZellePayment = false,
    this.envelopes = const [],
  });

  final String accountId;
  final String accountStatus;
  final String accountType;
  final List<String> accountCategories;
  final String name;
  final String nickName;
  final String shortNickName;
  final String availableBalance;
  final String currentBalance;
  final String openingBalance;
  final String principalBalance;
  final String availableCredit;
  final String maskedAccountNumber;
  final String displayName;
  final bool odOptionsEligible;
  final bool transferToEligible;
  final bool transferFromEligible;
  final bool quickBalanceEligible;
  final bool billPayEligible;
  final String? routingNumber;
  final bool defaultZellePayment;
  final List<Envelope> envelopes;

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountId: json['accountId'] as String,
      accountStatus: json['accountStatus'] as String,
      accountType: json['accountType'] as String,
      accountCategories: (json['accountCategories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      name: json['name'] as String,
      nickName: json['nickName'] as String,
      shortNickName: json['shortNickName'] as String,
      availableBalance: json['availableBalance'] as String,
      currentBalance: json['currentBalance'] as String,
      openingBalance: json['openingBalance'] as String,
      principalBalance: json['principalBalance'] as String,
      availableCredit: json['availableCredit'] as String,
      maskedAccountNumber: json['maskedAccountNumber'] as String,
      displayName: json['displayName'] as String,
      odOptionsEligible: json['odOptionsEligible'] as bool? ?? false,
      transferToEligible: json['transferToEligible'] as bool? ?? false,
      transferFromEligible: json['transferFromEligible'] as bool? ?? false,
      quickBalanceEligible: json['quickBalanceEligible'] as bool? ?? false,
      billPayEligible: json['billPayEligible'] as bool? ?? false,
      routingNumber: json['routingNumber'] as String?,
      defaultZellePayment: json['defaultZellePayment'] as bool? ?? false,
      envelopes: (json['account-deposits-envelopes'] as List<dynamic>?)
              ?.map((e) => Envelope.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

class Envelope {
  const Envelope({
    required this.envelopeId,
    required this.envelopeName,
    required this.envelopeStatus,
    required this.envelopeBalance,
    required this.accountId,
    this.category,
    this.quickTipId,
    this.envelopeCreatedDate,
    this.envelopeUpdatedDate,
    this.goals = const [],
  });

  final String envelopeId;
  final String envelopeName;
  final String envelopeStatus;
  final String envelopeBalance;
  final String accountId;
  final EnvelopeCategory? category;
  final String? quickTipId;
  final String? envelopeCreatedDate;
  final String? envelopeUpdatedDate;
  final List<EnvelopeGoal> goals;

  factory Envelope.fromJson(Map<String, dynamic> json) {
    final categoryJson =
        json['referenceEnvelopecategory'] as Map<String, dynamic>?;
    return Envelope(
      envelopeId: json['accountDepositsEnvelopeId'] as String,
      envelopeName: json['envelopeName'] as String,
      envelopeStatus: json['envelopeStatus'] as String,
      envelopeBalance: json['envelopeBalance'] as String,
      accountId: json['accountId'] as String,
      category: categoryJson != null
          ? EnvelopeCategory.fromJson(categoryJson)
          : null,
      quickTipId: json['quickTipId'] as String?,
      envelopeCreatedDate: json['envelopeCreatedDate'] as String?,
      envelopeUpdatedDate: json['envelopeUpdatedDate'] as String?,
      goals: (json['account-deposits-envelopes-goals'] as List<dynamic>?)
              ?.map(
                  (e) => EnvelopeGoal.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

class EnvelopeCategory {
  const EnvelopeCategory({
    required this.id,
    required this.name,
    required this.type,
  });

  final String id;
  final String name;
  final String type;

  factory EnvelopeCategory.fromJson(Map<String, dynamic> json) {
    return EnvelopeCategory(
      id: json['referenceEnvelopecategoryId'] as String,
      name: json['envelopecategoryName'] as String,
      type: json['envelopecategoryType'] as String,
    );
  }
}

class EnvelopeGoal {
  const EnvelopeGoal({
    required this.goalId,
    required this.envelopeId,
    required this.goalStatus,
    required this.targetAmount,
    required this.targetDate,
    required this.completionPercentage,
    this.goalCreatedDate,
    this.goalUpdatedDate,
  });

  final String goalId;
  final String envelopeId;
  final String goalStatus;
  final String targetAmount;
  final String targetDate;
  final String completionPercentage;
  final String? goalCreatedDate;
  final String? goalUpdatedDate;

  factory EnvelopeGoal.fromJson(Map<String, dynamic> json) {
    return EnvelopeGoal(
      goalId: json['accountDepositsEnvelopesGoalId'] as String,
      envelopeId: json['accountDepositsEnvelopeId'] as String,
      goalStatus: json['goalStatus'] as String,
      targetAmount: json['goalTargetAmount'] as String,
      targetDate: json['goalTargetDate'] as String,
      completionPercentage: json['goalCompletionPercentage'] as String,
      goalCreatedDate: json['goalCreatedDate'] as String?,
      goalUpdatedDate: json['goalUpdatedDate'] as String?,
    );
  }
}
