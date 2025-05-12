import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/bloc/card_market_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/plaid_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/tutorial_coach_mark/util.dart';
import 'package:lottie/lottie.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ShareYourPreferences extends StatefulWidget {
  const ShareYourPreferences({super.key});

  @override
  State<ShareYourPreferences> createState() => _ShareYourPreferencesState();
}

class _ShareYourPreferencesState extends State<ShareYourPreferences> {
  final controller = sl<PlaidBloc>();

  onSuccessPlaid(LinkSuccess event) {
    final cardData = ModalRoute.of(context)!.settings.arguments as CardModel;
    final token = event.publicToken;
    AppLocalStorage.putPlaidInstitutionName(event.metadata.institution!.name);
    controller.refreshPlaidAccessToken(token);
    CardModel card = cardData.copyWith(
      installedTime: DateTime.now(),
      name: AppLocalStorage.user!.name,
      cardValue: "1",
      userId: AppLocalStorage.hushhId!,
      coins: "10"
    );
    sl<CardMarketBloc>().add(
        InsertCardInUserInstalledCardsEvent(card, context));
  }

  @override
  Widget build(BuildContext context) {
    final cardData = ModalRoute.of(context)!.settings.arguments as CardModel;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey)),
                child: const Center(
                    child: Icon(
                  Icons.arrow_back_ios_new_sharp,
                  color: Colors.black,
                )))),
        title: const Padding(
          padding: EdgeInsets.only(top: 15.0),
          // Adjust the top padding as needed
          child: Text(
            'Share your preferences',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Figtree',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        width: 100.w,
        child: Padding(
          padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 14),
              SizedBox(
                width: 327,
                child: Text(
                  'You are all set!\nShare your ${cardData.brandName} preferences to earn 50 Hushh coins✨',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF363636),
                    fontSize: 16,
                    fontFamily: 'Figtree',
                    fontWeight: FontWeight.w500,
                    height: 1,
                    letterSpacing: -0.64,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Lottie.asset(
                    'assets/coin_loading.json', // Replace with your GIF file path
                  ),
                ),
              ),
              BlocListener(
                bloc: sl<CardMarketBloc>(),
                listener: (context, state) {
                  if (state is CardQuestionsFetchedState) {
                    if (
                        (sl<CardMarketBloc>().cardQuestions?.isNotEmpty ??
                                false) ||
                        cardData.id == Constants.businessCardId) {
                      Navigator.pushNamed(
                          context,
                          cardData.id == Constants.businessCardId
                              ? AppRoutes.cardMarketPlace.businessCardQuestions
                              : AppRoutes.cardMarketPlace.cardQuestions,
                          arguments: cardData);
                    } else {
                      CardModel card = cardData.copyWith(
                        installedTime: DateTime.now(),
                        name: AppLocalStorage.user!.name,
                        cardValue: "1",
                        userId: AppLocalStorage.hushhId!,
                        coins: "10"
                      );
                      sl<CardMarketBloc>().add(
                          InsertCardInUserInstalledCardsEvent(card, context));
                    }
                  }
                },
                child: HushhLinearGradientButton(
                    text: 'Take Me There',
                    onTap: () {
                      if (cardData.id == Constants.financeCardId) {
                        PlaidLink.onSuccess.listen(onSuccessPlaid);
                        controller.createLinkTokenConfiguration(context);
                      } else {
                        sl<CardMarketBloc>()
                            .add(FetchCardQuestionsEvent(cardData.id!, context));
                      }
                    }),
              ),
              if (Platform.isIOS) const SizedBox(height: 26),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
