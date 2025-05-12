import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/bloc/card_market_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/user_preference.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:lottie/lottie.dart';

class CardLoaderScreenArgs {
  final CardModel cardData;
  final String coins;
  final String cardCoins;
  final List<UserPreference> userSelections;
  final String? audioValue;

  const CardLoaderScreenArgs(
      {required this.cardData,
      required this.coins,
      this.audioValue,
      required this.cardCoins,
      required this.userSelections});
}

class CardLoaderPage extends StatefulWidget {
  const CardLoaderPage({super.key});

  @override
  State<CardLoaderPage> createState() => _CardLoaderPageState();
}

class _CardLoaderPageState extends State<CardLoaderPage> {
  postData() async {
    final args =
        ModalRoute.of(context)!.settings.arguments as CardLoaderScreenArgs;
    CardModel cardData = args.cardData;
    final userSelections = args.userSelections;
    final bidValue = args.coins;
    log("FINALL:${userSelections.map((e) => jsonEncode(e.toJson())).toList()}");
    cardData = cardData.copyWith(
        audioUrl: args.audioValue,
        cardValue: bidValue.toString().isEmpty ? "1" : bidValue.toString(),
        userId: AppLocalStorage.hushhId!,
        coins: "50",
        cardCurrency: sl<HomePageBloc>().currency.name,
        preferences: userSelections,
        name: AppLocalStorage.user!.name,
        installedTime: DateTime.now());
    sl<CardMarketBloc>().add(InsertCardInUserInstalledCardsEvent(cardData, context));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      postData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 86.85),
                SizedBox(
                  width: 300,
                  height: 300,
                  child: Lottie.asset(
                    'assets/card_loading_anim.json',
                  ),
                ),
                const SizedBox(height: 19),
                const SizedBox(
                  width: 327,
                  child: Text(
                    'Your personalized card is in the works! Hang tight while we tailor it just for you. By the way, 5 Hushh Coins have just been added to your account! 🎉',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF525252),
                      fontSize: 18,
                      fontFamily: 'Figtree',
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
