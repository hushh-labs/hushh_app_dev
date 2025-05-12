import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/core/components/shimmer_arrows.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:toastification/toastification.dart';

class UserCardWalletInfoCoffeeDetailsSection extends StatefulWidget {
  final CardModel cardData;

  const UserCardWalletInfoCoffeeDetailsSection(
      {super.key, required this.cardData});

  @override
  State<UserCardWalletInfoCoffeeDetailsSection> createState() =>
      _UserCardWalletInfoCoffeeDetailsSectionState();
}

class _UserCardWalletInfoCoffeeDetailsSectionState
    extends State<UserCardWalletInfoCoffeeDetailsSection> {
  @override
  void initState() {
    sl<CardWalletPageBloc>().add(FetchTravelDetailsEvent(widget.cardData));
    super.initState();
  }

  final canOrderCoffee = true;

  @override
  Widget build(BuildContext context) {
    return !canOrderCoffee
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    ToastManager(Toast(
                            title: 'Coming Soon',
                            type: ToastificationType.info))
                        .show(context);
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(colors: [
                          Color(0xFF76492E),
                          Color(0xFFC67C4E),
                        ])),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order Coffee',
                          style: TextStyle(color: Colors.white),
                        ),
                        ShimmerArrows()
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }
}

class FavouriteLocationsList extends StatelessWidget {
  final List<String> places;
  final double spacing; // spacing between items
  final TextStyle? textStyle;
  final EdgeInsets padding;

  const FavouriteLocationsList({
    Key? key,
    required this.places,
    this.spacing = 24.0,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            ...places
                .map((place) => Padding(
                      padding: EdgeInsets.only(right: spacing),
                      child: Text(
                        place,
                        style: textStyle ??
                            const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                            ),
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}

class TravelListTile extends StatelessWidget {
  final DateTime? dateTime;
  final TravelType travelType;
  final String arrivalDestination;
  final String departureDestination;

  const TravelListTile({
    Key? key,
    this.dateTime,
    required this.travelType,
    required this.arrivalDestination,
    required this.departureDestination,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              dateTime == null
                  ? 'N/A'
                  : '${_getMonthName(dateTime!.month)} ${dateTime!.day}${_getOrdinalIndicator(dateTime!.day)}'
                      .toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              travelType.icon,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              '$departureDestination - $arrivalDestination',
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 32)
        ],
      ),
    );
  }

  String _getOrdinalIndicator(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];
    return months[month - 1];
  }
}
