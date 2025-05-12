import 'dart:async';

import 'package:hushh_app/currency_converter/currency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/receipt_model.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/data/models/filter_model.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/data/models/receipt_radar_history.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/domain/usecases/fetch_receipt_radar_insights_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/domain/usecases/insert_receipt_radar_history_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/pages/receipt_radar_insights/insights_models.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/pages/receipt_radar_utils.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:intl/intl.dart';

import '../../../../../../../currency_converter/currency_converter.dart';

part 'events.dart';

part 'states.dart';

class ReceiptRadarBloc extends Bloc<ReceiptRadarEvent, ReceiptRadarState> {
  final FetchReceiptRadarInsightsUseCase fetchReceiptRadarInsightsUseCase;
  final UpdateReceiptRadarHistoryUseCase updateReceiptRadarHistoryUseCase;

  String? accessToken;

  ReceiptRadarBloc(
    this.fetchReceiptRadarInsightsUseCase,
    this.updateReceiptRadarHistoryUseCase,
  ) : super(ReceiptRadarInitialState()) {
    on<FetchInsightsEvent>(fetchInsightsEvent);
    on<ResetFiltersEvent>(resetFiltersEvent);
    on<ApplyFiltersEvent>(applyFiltersEvent);
    on<UpdateReceiptRadarHistoryEvent>(updateReceiptRadarHistoryEvent);
    on<FetchCategoriesFromReceiptsEvent>(fetchCategoriesFromReceiptsEvent);
  }

  // insights
  SpendingData? spendingData;

  List<Brand> topBrands = [
    // Brand('Apple', 'https://via.placeholder.com/40'),
    // Brand('Samsung', 'https://via.placeholder.com/40'),
    // Brand('Google', 'https://via.placeholder.com/40'),
    // Brand('Razor', 'https://via.placeholder.com/40'),
    // Brand('HP', 'https://via.placeholder.com/40'),
    // Brand('Dell', 'https://via.placeholder.com/40'),
  ];

  List<Brand> repeatBrands = [
    // Brand('Google', 'https://via.placeholder.com/40'),
    // Brand('HP', 'https://via.placeholder.com/40'),
    // Brand('Dell', 'https://via.placeholder.com/40'),
  ];

  Map<String, double> spendingByBrand = {
    // 'Apple': 50,
    // 'Razor': 30,
    // 'Dell': 20,
  };

  List<MapEntry<String, double>> spendingByBrandList = [];

  List<ExpenseCategory> categories = [];

  // filters
  ReceiptRadarSortType selectedSortType = ReceiptRadarSortType.newestFirst;
  List<ReceiptModel>? filterBasedReceipts;

  List<ReceiptModel>? receipts;

  Future<void> processReceipts(List<ReceiptModel> receipts) async {
    double totalSpending = 0;
    int transactionCount = receipts.length;
    Map<String, int> brandFrequency = {};
    Set<String> topBrands = {};
    Set<String> repeatBrands = {};

    DateTime now = DateTime.now();
    DateTime lastMonth = DateTime(now.year, now.month - 1, now.day);
    DateTime startOfMonth = DateTime(now.year, now.month, 1);

    double thisMonthSpending = 0;
    double lastMonthSpending = 0;

    Currency userCurrency = sl<HomePageBloc>().currency;

    // Collect unique conversions
    Map<String, double> uniqueConversions = {};
    for (var receipt in receipts) {
      if (receipt.currencyObj != userCurrency) {
        String conversionKey = '${receipt.currencyObj}-${userCurrency}';
        if (!uniqueConversions.containsKey(conversionKey)) {
          uniqueConversions[conversionKey] = 1.0; // Placeholder for conversion
        }
      }
    }

    // Perform all unique conversions concurrently
    Map<String, double> conversionRates = {};
    await Future.wait(uniqueConversions.keys.map((key) async {
      var parts = key.split('-');
      Currency fromCurrency = Currency.values.firstWhere((e) => e.toString() == parts[0]);
      Currency toCurrency = Currency.values.firstWhere((e) => e.toString() == parts[1]);

      conversionRates[key] = (await CurrencyConverter.convert(
        from: fromCurrency,
        to: toCurrency,
        amount: 1,
      ))!;
    }));

    Map<String, double> spendingByBrand = {};
    for (var receipt in receipts) {
      try {
        // Get receipt total based on its currency
        double receiptTotal = 0.0;
        if (receipt.currencyObj == Currency.inr) {
          receiptTotal = receipt.inrTotalCost ?? 0;
        } else if (receipt.currencyObj == Currency.usd) {
          receiptTotal = receipt.usdTotalCost ?? 0;
        }

        // Convert to user's preferred currency
        if (receipt.currencyObj != userCurrency) {
          String conversionKey = '${receipt.currencyObj}-${userCurrency}';
          receiptTotal *= conversionRates[conversionKey] ?? 1;
        }

        // Add to total spending
        totalSpending += receiptTotal;

        // Process spending by date
        DateTime purchaseDate = receipt.finalDate;

        if (purchaseDate.isAfter(startOfMonth)) {
          thisMonthSpending += receiptTotal;
        } else if (purchaseDate.isAfter(lastMonth) &&
            purchaseDate.isBefore(startOfMonth)) {
          lastMonthSpending += receiptTotal;
        }

        // Track spending by brand
        final String brandName = receipt.company ?? 'N/A';
        spendingByBrand[brandName] = (spendingByBrand[brandName] ?? 0) + receiptTotal;
        brandFrequency[brandName] = (brandFrequency[brandName] ?? 0) + 1;
        topBrands.add(brandName);
      } catch (_) {
        continue;
      }
    }

    // Track repeat brands
    repeatBrands.addAll(brandFrequency.entries
        .where((entry) => entry.value > 1)
        .map((entry) => entry.key));

    // Calculate average transaction value
    double averageTransaction = totalSpending / transactionCount;

    // Calculate changePercentage
    double changePercentage = 0;
    if (lastMonthSpending > 0) {
      changePercentage =
          ((thisMonthSpending - lastMonthSpending) / lastMonthSpending) * 100;
    } else {
      changePercentage = 100;
    }

    // Populate brand lists
    this.topBrands = topBrands
        .map((brand) {
      String? logo = receipts.firstWhere((receipt) {
        final String brandName = receipt.company ?? 'N/A';
        return brandName == brand;
      }).logo;
      return Brand(brand, logo);
    })
        .where((element) => element.logo?.isNotEmpty ?? false)
        .toList();

    this.repeatBrands = repeatBrands.map((brand) {
      String? logo = receipts.firstWhere((receipt) {
        final String brandName = receipt.company ?? 'N/A';
        return brandName == brand;
      }).logo;
      return Brand(brand, logo);
    }).toList();

    // Update spendingByBrand with percentages
    spendingByBrand.updateAll((key, value) => (value / totalSpending) * 100);

    var sortedEntries = spendingByBrand.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Get the top 3 entries
    spendingByBrandList = sortedEntries.take(3).toList();

    // Populate SpendingData
    spendingData =
        SpendingData(totalSpending, changePercentage, averageTransaction);

    emit(ReceiptRadarFetchedState());
  }

  FutureOr<void> fetchInsightsEvent(
      FetchInsightsEvent event, Emitter<ReceiptRadarState> emit) async {
    emit(ReceiptRadarFetchingState());
    if (event.receipts != null) {
      processReceipts(event.receipts!);
    } else {
      final result = await fetchReceiptRadarInsightsUseCase(uid: event.uid);
      result.fold((l) => null, (r) {
        print("FOUND RECEIPTS:::${r.length}, ${event.brandName?.toLowerCase()}");
        r = r.where((element) {
          final String brandName =
          (((element.brand?.trim().isNotEmpty ?? false)
              ? element.brand
              : element.company) as String);
          return (brandName.toLowerCase() ==
              event.brandName?.toLowerCase()) || (element.brandCategory?.toLowerCase() ?? "") == (event.brandCategory?.toLowerCase());
        }).toList();
        if (r.isNotEmpty) {
          processReceipts(r);
        } else {
          emit(ReceiptRadarFetchedState());
        }
      });
    }
  }

  int sortReceipts(ReceiptModel receiptA, ReceiptModel receiptB) {
    return selectedSortType == ReceiptRadarSortType.newestFirst
        ? receiptB.finalDate.compareTo(receiptA.finalDate)
        : selectedSortType == ReceiptRadarSortType.oldestFirst
            ? receiptA.finalDate.compareTo(receiptB.finalDate)
            : selectedSortType == ReceiptRadarSortType.lowToHighTotalPrice
                ? (receiptA.finalCost?.compareTo(receiptB.finalCost ?? 0) ?? 0)
                : selectedSortType == ReceiptRadarSortType.highToLowTotalPrice
                    ? (receiptB.finalCost?.compareTo(receiptA.finalCost ?? 0) ?? 0)
                    : 0;
  }

  Map<String, String> getSortedBrandList() {
    if (receipts == null) return {};
    Map<String, String> brands = {};

    for (var receipt in receipts!) {
      var brandName = receipt.company;
      brands[brandName ?? 'N/A'] = receipt.messageId!;
    }

    List<MapEntry<String, String>> brandsList = [];

    for (var entry in brands.entries) {
      brandsList.add(MapEntry(entry.key, entry.value));
    }

    // Sort brandsList if necessary, depending on your criteria (e.g., alphabetically by brand name)
    brandsList.sort((a, b) => a.key.compareTo(b.key));

    // Convert sorted list back to map
    return Map<String, String>.fromEntries(brandsList);
  }

  FutureOr<void> resetFiltersEvent(
      ResetFiltersEvent event, Emitter<ReceiptRadarState> emit) async {
    add(const ApplyFiltersEvent(
        [], [], [], [], ReceiptRadarSortType.newestFirst));
  }

  FutureOr<void> applyFiltersEvent(
      ApplyFiltersEvent event, Emitter<ReceiptRadarState> emit) async {
    emit(ReceiptRadarFilterUpdatingState());
    Set<String> allReceiptsIds = {
      for (var list
          in event.brands.where((element) => element.isSelected).toList())
        ...?list.ids,
      for (var list
          in event.categories.where((element) => element.isSelected).toList())
        ...?list.ids,
      for (var list
          in event.domains.where((element) => element.isSelected).toList())
        ...?list.ids,
      for (var list
          in event.times.where((element) => element.isSelected).toList())
        ...?list.ids,
    };
    if (allReceiptsIds.isEmpty) {
      filterBasedReceipts = null;
    } else {
      filterBasedReceipts = (await sl<ReceiptRadarUtils>().fetchReceipts())
          .where((element) => allReceiptsIds.contains(element.messageId))
          .toList();
    }
    selectedSortType = event.updatedSortValue;
    emit(ReceiptRadarFilterUpdatedState());
  }

  FutureOr<void> updateReceiptRadarHistoryEvent(
      UpdateReceiptRadarHistoryEvent event,
      Emitter<ReceiptRadarState> emit) async {
    final result = await updateReceiptRadarHistoryUseCase(
        receiptRadarHistory: event.receiptRadarHistory);
    result.fold((l) {}, (r) {
      AppLocalStorage.setSessionIdForReceiptRadar(r);
    });
  }

  FutureOr<void> fetchCategoriesFromReceiptsEvent(FetchCategoriesFromReceiptsEvent event, Emitter<ReceiptRadarState> emit) async {
    emit(FetchingCategoriesFromReceiptsState());
    final receipts = this.receipts ?? [];
    Map<String, ExpenseCategory> categoryMap = {};
    Currency userCurrency = sl<HomePageBloc>().currency;

    // Collect unique conversions required
    Map<String, double> uniqueConversions = {};
    for (var receipt in receipts) {
      if (receipt.brandCategory?.isEmpty ?? true) {
        continue;
      }

      double receiptTotal = 0.0;
      if (receipt.currencyObj == Currency.inr) {
        receiptTotal = receipt.inrTotalCost ?? 0;
      } else if (receipt.currencyObj == Currency.usd) {
        receiptTotal = receipt.usdTotalCost ?? 0;
      }

      if (receipt.currencyObj != userCurrency) {
        String conversionKey = '${receipt.currencyObj}-${userCurrency}';
        if (!uniqueConversions.containsKey(conversionKey)) {
          uniqueConversions[conversionKey] =
              receiptTotal; // Add total for conversion
        }
      }
    }

    // Perform all unique conversions concurrently
    Map<String, double> conversionRates = {};
    await Future.wait(uniqueConversions.keys.map((key) async {
      var parts = key.split('-');
      Currency fromCurrency =
      Currency.values.firstWhere((e) => e.toString() == parts[0]);
      Currency toCurrency =
      Currency.values.firstWhere((e) => e.toString() == parts[1]);

      // Perform the conversion and store the result
      conversionRates[key] =
      await Utils().convertToUserCurrency(1, fromCurrency, toCurrency);
    }));

    // Process receipts using precomputed conversion rates
    for (var receipt in receipts) {
      if (receipt.brandCategory?.isEmpty ?? true) {
        continue;
      }

      String category = receipt.brandCategory!;
      double receiptTotal = 0.0;

      // Determine receipt total based on currencyObj
      if (receipt.currencyObj == Currency.inr) {
        receiptTotal = receipt.inrTotalCost ?? 0;
      } else if (receipt.currencyObj == Currency.usd) {
        receiptTotal = receipt.usdTotalCost ?? 0;
      }

      // Convert total using precomputed rates
      if (receipt.currencyObj != userCurrency) {
        String conversionKey = '${receipt.currencyObj}-${userCurrency}';
        receiptTotal *= conversionRates[conversionKey]!;
      }

      if (categoryMap.containsKey(category)) {
        // Update existing category
        var existingCategory = categoryMap[category]!;
        existingCategory.receiptIds.add(receipt.messageId!);
        existingCategory.amount += receiptTotal;
      } else {
        // Add a new category
        categoryMap[category] = ExpenseCategory(
          name: parseBrandCategoryEnum(category),
          currency: userCurrency,
          receiptIds: [receipt.messageId!],
          amount: receiptTotal,
        );
      }
    }

    categories = categoryMap.values.toList();
    emit(FetchedCategoriesFromReceiptsState());
  }
}
