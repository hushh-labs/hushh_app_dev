class TransactionBalance {
  final String accountId;
  final double currentBalance;
  final double? availableBalance;
  final String currency;

  TransactionBalance({
    required this.accountId,
    required this.currentBalance,
    this.availableBalance,
    required this.currency,
  });

  factory TransactionBalance.fromJson(Map<String, dynamic> json) {
    return TransactionBalance(
      accountId: json['account_id'],
      currentBalance: json['balances']['current'].toDouble(),
      availableBalance: json['balances']['available']?.toDouble(),
      currency: json['balances']['iso_currency_code'] ?? 'USD',
    );
  }

  Map<String, dynamic> toRpcParams() {
    return {
      '_account_id': accountId,
      '_current_balance': currentBalance,
      '_available_balance': availableBalance,
      '_currency': currency,
    };
  }
}