import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/add_card_widget.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/audio_component.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/browsing_behavior_widget.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/business_name_section.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/card_questions_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/editable_card_questions_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/health_card_data.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/shared_preferences_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/social_media_business_card_section.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/user_card_wallet_info_app_usage_details_section.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/user_card_wallet_info_coffee_details_section.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/user_card_wallet_info_expense_details_section.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/user_card_wallet_info_finance_details_section.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/user_card_wallet_info_insurance_details_section.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/user_card_wallet_info_purchased_items_section.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/user_card_wallet_info_travel_details_section.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/virtual_closet_view.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class UserCardWalletInfoDefaultDetailsSection extends StatefulWidget {
  final CardModel cardData;

  const UserCardWalletInfoDefaultDetailsSection(
      {super.key, required this.cardData});

  @override
  State<UserCardWalletInfoDefaultDetailsSection> createState() =>
      _UserCardWalletInfoDefaultDetailsSectionState();
}

class _UserCardWalletInfoDefaultDetailsSectionState
    extends State<UserCardWalletInfoDefaultDetailsSection> {
  @override
  Widget build(BuildContext context) {
    final controller = sl<CardWalletPageBloc>();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!(controller.cardData?.audioUrl?.startsWith('#') ?? true) &&
              (controller.cardData?.audioUrl?.trim() ?? "") != "") ...[
            BlocBuilder(
              bloc: controller,
              builder: (context, state) {
                return AudioPlayerWidget(
                  audioTranscription: controller.cardData?.audioTranscription,
                  audioUrl: controller.cardData?.audioUrl,
                );
              },
            ),
          ],
          if (widget.cardData.id == Constants.browseCardId) ...[
            const BrowsingBehaviorWidget(),
            const SizedBox(height: 26),
          ],
          if (widget.cardData.id == Constants.businessCardId) ...[
            BusinessNameSection(
                cardData: widget.cardData,
                onChange: (value) {
                  widget.cardData.brandPreferences.firstOrNull?.metadata?['answers']
                      ['business_name'] = value;

                  setState(() {});
                }),
            const SizedBox(height: 26),
            SocialMediaBusinessCardSection(cardData: widget.cardData),
            const SizedBox(height: 26),
          ],
          if (widget.cardData.id == Constants.expenseCardId) ...[
            UserCardWalletInfoExpenseDetailsSection(cardData: widget.cardData),
            const SizedBox(height: 26),
          ],
          if (widget.cardData.id == Constants.appUsageCardId) ...[
            UserCardWalletInfoAppUsageDetailsSection(cardData: widget.cardData),
            const SizedBox(height: 26),
          ],
          if (widget.cardData.id == Constants.financeCardId) ...[
            const UserCardWalletInfoFinanceDetailsSection(),
            const SizedBox(height: 26)
          ],
          if (!(widget.cardData.isPreferenceCard)) ...[
            BlocBuilder(
                bloc: sl<CardWalletPageBloc>(),
                builder: (context, _) {
                  return AddCardWidget(
                    cardType: CardType.brandCard,
                    cardData: widget.cardData,
                  );
                }),
            const SizedBox(height: 20),
            BlocBuilder(
                bloc: sl<CardWalletPageBloc>(),
                builder: (context, _) {
                  return AddCardWidget(
                    cardType: CardType.preferenceCard,
                    cardData: widget.cardData,
                  );
                }),
            const SizedBox(height: 26),
          ],
          if (widget.cardData.id == Constants.healthCardId) ...[
            const HealthInsights(),
            const SizedBox(height: 26),
          ],
          if (widget.cardData.id == Constants.insuranceCardId) ...[
            UserCardWalletInfoInsuranceDetailsSection(
                cardData: widget.cardData),
            const SizedBox(height: 26),
          ],
          if (widget.cardData.id == Constants.travelCardId) ...[
            UserCardWalletInfoTravelDetailsSection(cardData: widget.cardData),
            const SizedBox(height: 26),
          ],
          if (widget.cardData.id == Constants.coffeeCardId) ...[
            const SizedBox(height: 4),
            UserCardWalletInfoCoffeeDetailsSection(cardData: widget.cardData),
            const SizedBox(height: 26),
          ],
          if (widget.cardData.id != Constants.businessCardId) ...[
            BlocBuilder(
              bloc: controller,
              builder: (context, state) {
                if (widget.cardData.category == 'Hushh ID Card') {
                  return const EditableCardQuestionsListView(
                      customCardQuestionsType:
                          CustomCardQuestionsType.hushhIdCard);
                } else if (widget.cardData.category == "Demographic Card") {
                  return const EditableCardQuestionsListView(
                      customCardQuestionsType:
                          CustomCardQuestionsType.demographicCard);
                } else {
                  return const Column(
                    children: [
                      SharedPreferencesView(),
                      VirtualClosetView(),
                      CardQuestionsListView(),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 26),
            BlocBuilder(
              bloc: sl<CardWalletPageBloc>(),
              builder: (context, state) {
                if (widget.cardData.id == Constants.fashionCardId &&
                    (sl<CardWalletPageBloc>().purchasedItems?.isNotEmpty ??
                        false)) {
                  return Column(
                    children: [
                      const SizedBox(height: 4),
                      UserCardWalletInfoPurchasedItemsSection(
                          cardData: widget.cardData),
                      const SizedBox(height: 26),
                    ],
                  );
                }
                return const SizedBox();
              },
            )
          ],
        ],
      ),
    );
  }
}
