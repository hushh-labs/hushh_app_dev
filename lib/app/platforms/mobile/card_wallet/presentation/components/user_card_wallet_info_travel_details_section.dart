import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/destination_list_tile.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:intl/intl.dart';

class UserCardWalletInfoTravelDetailsSection extends StatefulWidget {
  final CardModel cardData;

  const UserCardWalletInfoTravelDetailsSection(
      {super.key, required this.cardData});

  @override
  State<UserCardWalletInfoTravelDetailsSection> createState() =>
      _UserCardWalletInfoTravelDetailsSectionState();
}

class _UserCardWalletInfoTravelDetailsSectionState
    extends State<UserCardWalletInfoTravelDetailsSection> {
  @override
  void initState() {
    sl<CardWalletPageBloc>().add(FetchTravelDetailsEvent(widget.cardData));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = sl<CardWalletPageBloc>();
    return controller.travelCardInsights == null
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Travel history'.toUpperCase(),
                  style: context.titleSmall?.copyWith(
                    color: const Color(0xFF737373),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  children: List.generate(
                    controller.travelCardInsights?.travelHistory.length ?? 0,
                    (index) {
                      final travelData =
                          controller.travelCardInsights!.travelHistory[index];
                      return TravelListTile(
                        dateTime: travelData.arrivalDate == null
                            ? null
                            : DateFormat('dd-MM-yyyy')
                                .parse(travelData.arrivalDate!),
                        travelType: travelData.travelType,
                        departureDestination:
                            travelData.departureDestination ?? 'N/A',
                        arrivalDestination:
                            travelData.arrivalDestination ?? 'N/A',
                      );
                    },
                  ),
                ),
                const SizedBox(height: 26),
                Text(
                  'Favorite Locations'.toUpperCase(),
                  style: context.titleSmall?.copyWith(
                    color: const Color(0xFF737373),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                FavouriteLocationsList(
                  places: controller
                          .travelCardInsights?.arrivalLocationFrequency.keys
                          .toList() ??
                      [],
                  spacing: 20,
                  padding: EdgeInsets.zero,
                  textStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      fontSize: 18),
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
          DestinationListTile(
            departureDestination: departureDestination,
            arrivalDestination: arrivalDestination,
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
