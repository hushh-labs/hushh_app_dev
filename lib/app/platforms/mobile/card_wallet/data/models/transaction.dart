class Transaction {
  final String transactionId;
  final String accountId;
  final DateTime date;
  final double amount;
  final String? category;
  final String? merchantName;
  final String? paymentChannel;
  final String? memo;

  Transaction({
    required this.transactionId,
    required this.accountId,
    required this.date,
    required this.amount,
    this.category,
    this.merchantName,
    this.paymentChannel,
    this.memo,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['transaction_id'],
      accountId: json['account_id'],
      date: DateTime.parse(json['date']),
      amount: json['amount'].toDouble(),
      category: json['category'] != null ? (json['category'] as List).join(', ') : null,
      merchantName: json['merchant_name'],
      paymentChannel: json['payment_channel'],
      memo: json['payment_meta']['memo'],
    );
  }

  Map<String, dynamic> toRpcParams() {
    return {
      '_transaction_id': transactionId,
      '_account_id': accountId,
      '_date': date.toIso8601String(),
      '_amount': amount,
      '_category': category,
      '_merchant_name': merchantName,
      '_payment_channel': paymentChannel,
      '_memo': memo,
    };
  }
}
