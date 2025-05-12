class TransactionModel {
  final String? image;
  final String title;
  final String desc;
  final DateTime dateTime;
  final String currency;
  final double amount;

  TransactionModel(
      {this.image,
      required this.title,
      required this.desc,
      required this.dateTime,
      required this.currency,
      required this.amount});

  factory TransactionModel.fromPaymentRequestJson(Map<String, dynamic> data) =>
      TransactionModel(
        image: data['image'],
        title: data['title'] ?? 'N/A',
        desc: data['description'] ?? 'N/A',
        dateTime: DateTime.tryParse(data['amount_paid_dt'] ?? '') ?? DateTime(1800),
        currency: data['currency'],
        amount: data['amount_payed'] ?? 0,
      );

  factory TransactionModel.fromReceiptJson(Map<String, dynamic> data) =>
      TransactionModel(
        image: data['logo'],
        title: "${data['brand']} ${data['purchase_category'] != null?'(${data['purchase_category']})':''}",
        desc: data['brand_category'] ?? '',
        dateTime: DateTime.parse(data['receipt_date']),
        currency: data['currency'] ?? 'INR',
        amount: double.tryParse(data['total_cost'].toString()) ?? 0,
      );
}
