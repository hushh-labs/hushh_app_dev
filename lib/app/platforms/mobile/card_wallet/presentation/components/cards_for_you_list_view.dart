import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/brand_card_list_view.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:palette_generator/palette_generator.dart';

class CardsForYouListView extends StatefulWidget {
  const CardsForYouListView({super.key});

  @override
  State<CardsForYouListView> createState() => _CardsForYouListViewState();
}

class _CardsForYouListViewState extends State<CardsForYouListView> {
  // Future<void> generateColors() async {
  //   final recommendedCards = sl<CardWalletPageBloc>().recommendedCards!.reversed.toList();
  //   List<String> logos = recommendedCards.map((e) => e.logo).toList();
  //   for(String logo in logos) {
  //     final palette = await PaletteGenerator.fromImageProvider(NetworkImage(logo));
  //     sl<CardWalletPageBloc>().recommendedCardsColors.add(palette.dominantColor!.color);
  //   }
  //   setState(() {});
  // }

  @override
  void initState() {
    // if(sl<CardWalletPageBloc>().recommendedCardsColors.isEmpty) {
    //   generateColors();
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final recommendedCards = sl<CardWalletPageBloc>().recommendedCards!.reversed.toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
            recommendedCards.length,
            (index) => Padding(
                  padding: EdgeInsets.only(
                      left: 16,
                      right: index == recommendedCards.length - 1 ? 16 : 0),
                  child: BrandCardWidget(
                    brand: recommendedCards[index],
                    isRecommendedCard: true,
                    index: index,
                    showQr: false,
                    isDetailsScreen: false,
                  ),
                )),
      ),
    );
  }
}
