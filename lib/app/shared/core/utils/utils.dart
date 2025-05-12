import 'dart:typed_data';

import 'package:hushh_app/currency_converter/currency.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/app_usage_data.dart';
import 'package:tuple/tuple.dart';

abstract class BaseUtils {
  Future<Uint8List?> getImageFromPdf(String path);

  int getWeekdayIndex(String weekday);

  TimeOfDay convertTimeOfDayTimeZone(TimeOfDay timeOfDay, String timeZone);

  String moneyToHushhCoins(String money);

  int moneyToHushhCoinsInInt(double amount);

  String getCurrencySymbol(Currency currency);

  Currency? getCurrencyFromCountrySymbol(String? isoToCurrencyMap);

  Currency? getCurrencyFromCurrencySymbol(String? isoToCurrencyMap);

  String getCurrencyShortenSymbol(Currency currency);

  double hushhCoinsToMoney(int coins);

  Color getTextColor(Color color);

  String formatDurationFromDouble(double usage);

  String formatDuration(int seconds);

  String? extractUrl(String text);

  Future<List<AppUsageData>> fetchAppUsage(Tuple2<int, String> data);

  Future<double> convertToUserCurrency(
      double amount, Currency from, Currency to);

  void showLoader(BuildContext context);
}
