import 'package:hushh_app/currency_converter/currency.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';

class Brand {
  final String name;
  final String? logo;

  Brand(this.name, this.logo);
}

class ExpenseCategory {
  final BrandCategoryEnum name;
  final Currency currency;
  double amount;
  List<String> receiptIds;

  ExpenseCategory(
      {required this.name,
      required this.currency,
      required this.amount,
      required this.receiptIds});
}

class SpendingData {
  final double totalSpending;
  final double changePercentage;
  final double averageTransaction;

  SpendingData(
      this.totalSpending, this.changePercentage, this.averageTransaction);
}

class LoyaltyMetrics {
  final List<Brand> repeatBrands;

  LoyaltyMetrics(this.repeatBrands);
}
