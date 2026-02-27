enum AccountType {
  checking,
  savings,
  personalCreditLine,
  creditCard;

  String get label {
    switch (this) {
      case AccountType.checking:
        return 'Checking';
      case AccountType.savings:
        return 'Savings';
      case AccountType.personalCreditLine:
        return 'Personal Credit Line';
      case AccountType.creditCard:
        return 'Credit Card';
    }
  }

  String get balanceLabel {
    switch (this) {
      case AccountType.checking:
      case AccountType.savings:
        return 'Account Balance';
      case AccountType.personalCreditLine:
      case AccountType.creditCard:
        return 'Available Credit';
    }
  }
}
