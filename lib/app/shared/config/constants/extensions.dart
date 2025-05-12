import 'package:blur/blur.dart';
import 'package:hushh_app/currency_converter/currency.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:http/http.dart' as http;
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

extension WidgetExtensions on Widget {
  Widget toShimmer(bool cond) {
    return cond
        ? Shimmer.fromColors(
            baseColor: Colors.grey.shade400,
            highlightColor: Colors.grey.shade300,
            child: this)
        : this;
  }

  Widget toBlur(bool cond) {
    return cond
        ? blurred(blur: 5, colorOpacity: 0, blurColor: Colors.grey.shade700)
        : this;
  }
}

extension CapitalizeExtension on String {
  bool doesStringStartsWithHttp() {
    return substring(
    0, 4)
        .toLowerCase() ==
    "http";
  }
  String phoneNumber() {
    return replaceAll(" ", "")
        .replaceAll('-', '')
        .replaceAll('(', '')
        .replaceAll(')', '');
  }

  String formatPhoneNumber() {
    // Remove any non-digit characters from the raw phone number string
    String digitsOnly = replaceAll(RegExp(r'\D+'), '');

    // Check if the phone number has a country code and format accordingly
    if (digitsOnly.length == 10) {
      return '(${digitsOnly.substring(0, 3)}) ${digitsOnly.substring(3, 6)}-${digitsOnly.substring(6)}';
    } else if (digitsOnly.length == 11) {
      return '${digitsOnly.substring(0, 1)} (${digitsOnly.substring(1, 4)}) ${digitsOnly.substring(4, 7)}-${digitsOnly.substring(7)}';
    } else {
      // Return the raw phone number if it doesn't match expected lengths
      return this;
    }
  }

  int calculateAge() {
    // Parse the date of birth string into a DateTime object
    DateTime dob;
    if (split('-').last.length != 4) {
      dob = DateFormat('yyyy-MM-dd').parse(this);
    } else {
      dob = DateFormat('dd-MM-yyyy').parse(this);
    }

    // Get the current date
    DateTime now = DateTime.now();

    // Calculate the difference in years between the current date and the date of birth
    int age = now.year - dob.year;

    // Adjust age if the user's birthday hasn't occurred yet this year
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }

    return age;
  }

  String capitalize() {
    if (isEmpty) {
      return this;
    }
    List<String> words = split(" ");
    if (words.isEmpty) {
      return this;
    }
    // Capitalize the first letter of each word
    List<String> capitalizedWords = words.map((word) {
      if (word.isNotEmpty) {
        return word.substring(0, 1).toUpperCase() + word.substring(1);
      } else {
        return word; // Preserve empty strings
      }
    }).toList();
    return capitalizedWords.join(" ");
  }
}

extension GmailExtension on gmail.MessagePart {
  // Function to check if a part has attachment
  bool hasAttachment() {
    return filename != null &&
        mimeType != null &&
        mimeType!.startsWith('application/');
  }

  // Function to get the attachment data
  Future<String?> getAttachmentData(http.Client client) async {
    final gmail.MessagePartBody? attachmentBody = body;
    if (attachmentBody != null && attachmentBody.attachmentId != null) {
      final gmail.MessagePartBody attachmentPart = await gmail.GmailApi(client)
          .users
          .messages
          .attachments
          .get('me', 'messageId', attachmentBody.attachmentId!);
      if (attachmentPart.data != null) {
        return attachmentPart.data;
      }
    }
    return null;
  }
}

extension CurrencyExtension on Currency {
  String shorten() {
    return Utils().getCurrencyShortenSymbol(this);
  }
}

extension TextStyleExtension on TextStyle {
  TextStyle? get inter => copyWith(fontFamily: 'Inter');
}

extension ReceiptRadarSortTypeExtension on ReceiptRadarSortType {
  String get text {
    switch (this) {
      case ReceiptRadarSortType.newestFirst:
        return 'Newest first';
      case ReceiptRadarSortType.oldestFirst:
        return 'Oldest first';
      case ReceiptRadarSortType.lowToHighTotalPrice:
        return 'Low to High';
      case ReceiptRadarSortType.highToLowTotalPrice:
        return 'High to Low';
    }
  }
}

extension TravelTypeExtension on TravelType {
  IconData get icon {
    switch (this) {
      case TravelType.bus:
        return Icons.directions_bus_outlined;
      case TravelType.train:
        return Icons.train_outlined;
      case TravelType.airplane:
        return Icons.flight_outlined;
      case TravelType.taxi:
        return Icons.local_taxi_outlined;
      case TravelType.bike:
        return Icons.pedal_bike_outlined;
      case TravelType.rickshaw:
        return Icons.electric_rickshaw_outlined;
    }
  }
}

extension BrandCategoryExtension on BrandCategoryEnum {
  String easy() {
    switch (this) {
      case BrandCategoryEnum.others:
        return 'Others';
      case BrandCategoryEnum.fashionAndApparel:
        return 'Fashion & Shopping';
      case BrandCategoryEnum.jewelryAndWatches:
        return 'Jewelry & Watches';
      case BrandCategoryEnum.beautyAndPersonalCare:
        return 'Personal care';
      case BrandCategoryEnum.automobiles:
        return 'Vehicle';
      case BrandCategoryEnum.realEstate:
        return 'Real Estate';
      case BrandCategoryEnum.travelAndLeisure:
        return 'Travel';
      case BrandCategoryEnum.homeAndLifestyle:
        return 'Home & Lifestyle';
      case BrandCategoryEnum.technologyAndElectronics:
        return 'Technology';
      case BrandCategoryEnum.sportsAndLeisure:
        return 'Sports';
      case BrandCategoryEnum.artAndCollectibles:
        return 'Art & Collectibles';
      case BrandCategoryEnum.healthAndWellness:
        return 'Health & Wellness';
      case BrandCategoryEnum.stationeryAndWritingInstruments:
        return 'Stationery';
      case BrandCategoryEnum.childrenAndBaby:
        return 'Children/Baby';
      case BrandCategoryEnum.petAccessories:
        return 'Pet';
      case BrandCategoryEnum.services:
        return 'General Services';
      case BrandCategoryEnum.financialServices:
        return 'Financial Services';
      case BrandCategoryEnum.airlineServices:
        return 'Flights';
      case BrandCategoryEnum.accommodationServices:
        return 'Hotels & Accommodation';
      case BrandCategoryEnum.beveragesServices:
        return 'Beverages';
      case BrandCategoryEnum.culinaryServices:
        return 'Restaurant & Fast Food';
      case BrandCategoryEnum.insurance:
        return 'Insurance';
      case BrandCategoryEnum.foodDeliveryService:
        return 'Food Delivery';
      case BrandCategoryEnum.hospitality:
        return 'Hospitality';
      case BrandCategoryEnum.coupons:
        return 'Coupons';
    }
  }

  Color color() {
    switch (this) {
      case BrandCategoryEnum.others:
        return Colors.black;
      case BrandCategoryEnum.coupons:
        return Colors.deepPurple;
      case BrandCategoryEnum.hospitality:
        return Colors.brown;
      case BrandCategoryEnum.fashionAndApparel:
        return Colors.pinkAccent;
      case BrandCategoryEnum.jewelryAndWatches:
        return Colors.yellowAccent;
      case BrandCategoryEnum.beautyAndPersonalCare:
        return Colors.deepOrangeAccent;
      case BrandCategoryEnum.automobiles:
        return Colors.brown;
      case BrandCategoryEnum.realEstate:
        return Colors.deepPurple;
      case BrandCategoryEnum.travelAndLeisure:
        return Colors.blueAccent;
      case BrandCategoryEnum.homeAndLifestyle:
        return Colors.blueGrey;
      case BrandCategoryEnum.technologyAndElectronics:
        return Colors.greenAccent;
      case BrandCategoryEnum.sportsAndLeisure:
        return Colors.indigoAccent;
      case BrandCategoryEnum.artAndCollectibles:
        return Colors.tealAccent;
      case BrandCategoryEnum.healthAndWellness:
        return Colors.redAccent;
      case BrandCategoryEnum.stationeryAndWritingInstruments:
        return Colors.cyan;
      case BrandCategoryEnum.childrenAndBaby:
        return Colors.yellow;
      case BrandCategoryEnum.petAccessories:
        return Colors.deepPurple;
      case BrandCategoryEnum.services:
        return Colors.black87;
      case BrandCategoryEnum.financialServices:
        return Colors.lightGreen;
      case BrandCategoryEnum.airlineServices:
        return Colors.blue;
      case BrandCategoryEnum.accommodationServices:
        return Colors.red;
      case BrandCategoryEnum.beveragesServices:
        return Colors.lightBlue;
      case BrandCategoryEnum.culinaryServices:
        return Colors.orangeAccent;
      case BrandCategoryEnum.insurance:
        return Colors.lightGreenAccent;
      case BrandCategoryEnum.foodDeliveryService:
        return Colors.orange;
    }
  }
}

extension DoubleExtensions on double {
  String toCommaSeparatedString() {
    final formatter = NumberFormat.decimalPattern(); // From intl package
    return formatter.format(this);
  }
}