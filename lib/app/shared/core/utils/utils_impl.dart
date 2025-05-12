import 'dart:developer';
import 'dart:typed_data';

import 'package:app_usage/app_usage.dart';
import 'package:hushh_app/currency_converter/currency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/app_usage_data.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/utils/utils.dart';
import 'package:pdf_image_renderer/pdf_image_renderer.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:tuple/tuple.dart';

import '../../../../currency_converter/currency_converter.dart';

class Utils implements BaseUtils {
  Utils() {
    tz.initializeTimeZones();
  }

  @override
  Future<Uint8List?> getImageFromPdf(String path) async {
    final pdf = PdfImageRenderer(path: path);
    await pdf.open();
    await pdf.openPage(pageIndex: 0);
    final size = await pdf.getPageSize(pageIndex: 0);
    final img = await pdf.renderPage(
      pageIndex: 0,
      x: 0,
      y: 0,
      width: size.width,
      height: size.height,
      scale: 1,
      background: Colors.white,
    );
    await pdf.closePage(pageIndex: 0);
    pdf.close();
    return img;
  }

  @override
  int getWeekdayIndex(String weekday) {
    const weekdayMap = {
      'monday': 0,
      'tuesday': 1,
      'wednesday': 2,
      'thursday': 3,
      'friday': 4,
      'saturday': 5,
      'sunday': 6,
    };
    return weekdayMap[weekday.toLowerCase()] ??
        (throw Exception('Invalid weekday: $weekday'));
  }

  @override
  TimeOfDay convertTimeOfDayTimeZone(TimeOfDay timeOfDay, String timeZone) {
    final location = tz.getLocation(timeZone);
    final now = DateTime.now();
    final localDateTime = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final convertedDateTime = tz.TZDateTime.from(localDateTime, location);
    return TimeOfDay(
        hour: convertedDateTime.hour, minute: convertedDateTime.minute);
  }

  @override
  String moneyToHushhCoins(String money) {
    double amount = double.parse(money);
    String currency = sl<HomePageBloc>().currency.shorten();
    return _convertToHushhCoins(amount, currency).toStringAsFixed(2);
  }

  @override
  int moneyToHushhCoinsInInt(double amount) {
    String currency = sl<HomePageBloc>().currency.shorten();
    return _convertToHushhCoins(amount, currency).toInt();
  }

  double _convertToHushhCoins(double amount, String currency) {
    const conversionRates = {
      '₹': 2.50,
      '\$': 0.01,
      '€': 0.000276,
    };
    if (!conversionRates.containsKey(currency)) {
      throw UnsupportedError("Unsupported currency: $currency");
    }
    return amount / conversionRates[currency]!;
  }

  @override
  String getCurrencySymbol(Currency currency) => currency.name;

  @override
  Currency? getCurrencyFromCountrySymbol(String? isoToCurrencyMap) {
    const countryCurrencyMap = {
      'IN': Currency.inr,
      'US': Currency.usd,
      'EU': Currency.eur
    };
    return countryCurrencyMap[isoToCurrencyMap];
  }

  @override
  Currency? getCurrencyFromCurrencySymbol(String? isoToCurrencyMap) {
    const currencyMap = {
      'INR': Currency.inr,
      'USD': Currency.usd,
      'EUR': Currency.eur
    };
    return currencyMap[isoToCurrencyMap];
  }

  @override
  String getCurrencyShortenSymbol(Currency currency) {
    const currencySymbols = {
      Currency.usd: "\$",
      Currency.eur: "€",
      Currency.inr: "₹"
    };
    return currencySymbols[currency] ?? defaultCurrency.shorten();
  }

  @override
  double hushhCoinsToMoney(int coins) {
    String currency = sl<HomePageBloc>().currency.shorten();
    return _convertToHushhCoins(coins.toDouble(), currency);
  }

  @override
  Color getTextColor(Color color) {
    double luminance =
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  @override
  String formatDurationFromDouble(double usage) {
    final hours = usage.floor();
    final minutes = ((usage - hours) * 60).round();
    return hours > 0 ? '${hours}h ${minutes}min' : '${minutes}min';
  }

  @override
  String formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours > 0 ? "${hours}hr " : ""}${minutes}min'.trim();
  }

  @override
  String? extractUrl(String text) {
    final urlPattern = RegExp(r'(https?:\/\/[^\s]+)', caseSensitive: false);
    return urlPattern.firstMatch(text)?.group(0);
  }

  @override
  Future<List<AppUsageData>> fetchAppUsage(Tuple2<int, String> data) async {
    Future<List<AppUsageData>> fetchUsageForPeriod(
        DateTime start, DateTime end, String hushhId) async {
      final usageData = await AppUsage().getAppUsage(start, end);
      return usageData
          .where((e) => e.startDate
              .isAfter(DateTime.now().subtract(const Duration(days: 7))))
          .map((e) => AppUsageData(
                hushhId: hushhId,
                createdAt: DateTime.now(),
                usage: e.usage.inSeconds,
                appId: e.packageName,
                lastForeground: e.lastForeground,
                startData: e.startDate,
                endData: e.endDate,
              ))
          .toList();
    }

    final futures = List.generate(data.item1, (i) {
      final end = DateTime.now().subtract(Duration(days: i));
      final start = end.subtract(const Duration(days: 1));
      return fetchUsageForPeriod(start, end, data.item2);
    });
    final results = await Future.wait(futures);
    return results.expand((e) => e).toList();
  }

  @override
  Future<double> convertToUserCurrency(
      double amount, Currency from, Currency to) async {
    try {
      if (from == to) return amount;
      return await CurrencyConverter.convert(
              from: from, to: to, amount: amount) ??
          amount;
    } catch (e) {
      log("Currency conversion failed: $e");
      return amount;
    }
  }

  @override
  void showLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}

typedef AsyncVoidFunction = Future<void> Function();

// Higher-order function that adds try-catch to an async function
Future tryAndRun(AsyncVoidFunction fn) async {
  return () async {
    try {
      await fn();
    } catch (e) {
      print('An error occurred: $e');
      // You can add more error handling logic here
    }
  };
}

BrandCategoryEnum parseBrandCategoryEnum(String category) {
  switch (category.trim().toLowerCase()) {
    case 'fashion and apparel':
      return BrandCategoryEnum.fashionAndApparel;
    case 'jewelry and watches':
      return BrandCategoryEnum.jewelryAndWatches;
    case 'beauty and personal care':
      return BrandCategoryEnum.beautyAndPersonalCare;
    case 'automobiles':
      return BrandCategoryEnum.automobiles;
    case 'real estate':
      return BrandCategoryEnum.realEstate;
    case 'travel and leisure':
    case 'travel':
      return BrandCategoryEnum.travelAndLeisure;
    case 'home and lifestyle':
      return BrandCategoryEnum.homeAndLifestyle;
    case 'technology and electronics':
      return BrandCategoryEnum.technologyAndElectronics;
    case 'sports and leisure':
      return BrandCategoryEnum.sportsAndLeisure;
    case 'art and collectibles':
      return BrandCategoryEnum.artAndCollectibles;
    case 'health and wellness':
      return BrandCategoryEnum.healthAndWellness;
    case 'stationery and writing instruments':
      return BrandCategoryEnum.stationeryAndWritingInstruments;
    case 'children and baby':
      return BrandCategoryEnum.childrenAndBaby;
    case 'pet accessories':
      return BrandCategoryEnum.petAccessories;
    case 'services':
      return BrandCategoryEnum.services;
    case 'financial services':
      return BrandCategoryEnum.financialServices;
    case 'airline services':
      return BrandCategoryEnum.airlineServices;
    case 'accommodation services':
      return BrandCategoryEnum.accommodationServices;
    case 'beverages services':
      return BrandCategoryEnum.beveragesServices;
    case 'culinary services':
      return BrandCategoryEnum.culinaryServices;
    case 'insurance':
      return BrandCategoryEnum.insurance;
    case 'food delivery services':
    case 'food_delievery_service':
      return BrandCategoryEnum.foodDeliveryService;
    case 'hospitality':
      return BrandCategoryEnum.hospitality;
    case 'coupons':
      return BrandCategoryEnum.coupons;
    case 'others':
      return BrandCategoryEnum.others;
    default:
      throw ArgumentError('Unknown category: $category');
  }
}