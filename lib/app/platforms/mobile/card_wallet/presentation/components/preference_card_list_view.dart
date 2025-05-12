import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/user.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/bloc/card_market_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/components/card_market_place_button.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/pages/card_bid_value.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/customer_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/qr_code_widget.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/card_wallet_info/card_wallet_info.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

double preferenceCardHeight = 25.h;

class PreferenceCardListView extends StatelessWidget {
  final UserModel? userModel;
  final bool isDetailsScreen;
  final Function()? onIndexChanged;

  const PreferenceCardListView(
      {super.key,
      required this.isDetailsScreen,
      this.userModel,
      this.onIndexChanged});

  @override
  Widget build(BuildContext context) {
    List<CardModel> brandCardList = sl<CardWalletPageBloc>().preferenceCards;
    return SizedBox(
      height: preferenceCardHeight + 5,
      width: double.infinity,
      child: Swiper(
        itemWidth: 100.w - 32,
        itemHeight: preferenceCardHeight,
        loop: true,
        onIndexChanged: (index) {
          sl<CardWalletPageBloc>().currentBrandCardIndex = index;
          onIndexChanged?.call();
        },
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          bool showQr = brandCardList.length < 4 ||
              (sl<CardWalletPageBloc>().currentBrandCardIndex == 0 &&
                  (index == 0 ||
                      index == 1 ||
                      index == brandCardList.length - 1)) ||
              (sl<CardWalletPageBloc>().currentBrandCardIndex ==
                      brandCardList.length - 1 &&
                  (index == 0 ||
                      index == brandCardList.length - 1 ||
                      index == brandCardList.length - 2)) ||
              (index == sl<CardWalletPageBloc>().currentBrandCardIndex - 1 ||
                  index == sl<CardWalletPageBloc>().currentBrandCardIndex ||
                  index == sl<CardWalletPageBloc>().currentBrandCardIndex + 1);
          return Hero(
            tag: UniqueKey(),
            child: PreferenceCardWidget(
              cardData: brandCardList[index],
              userName: AppLocalStorage.user?.name ?? '',
              user: userModel,
              showQr: showQr,
              isDetailsScreen: isDetailsScreen,
            ),
          );
        },
        itemCount: brandCardList.length,
        layout: SwiperLayout.STACK,
      ),
    );
  }
}

class PreferenceCardWidget extends StatefulWidget {
  final CardModel cardData;
  final String userName;
  final bool ignore;
  final UserModel? user;
  final bool isDetailsScreen;
  final bool showQr;

  const PreferenceCardWidget(
      {super.key,
      required this.cardData,
      required this.userName,
      this.ignore = false,
      this.user,
      this.isDetailsScreen = false,
      this.showQr = true});

  @override
  State<PreferenceCardWidget> createState() => _PreferenceCardWidgetState();
}

class _PreferenceCardWidgetState extends State<PreferenceCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
          width: 100.w - 32,
          key: Key(widget.cardData.id.toString()),
          height: preferenceCardHeight,
          child: widget.ignore || true
              ? CustomCard(
                  isDetailsScreen: widget.isDetailsScreen,
                  cardData: widget.cardData,
                  ignore: widget.ignore,
                  user: widget.user,
                  userName: widget.userName,
                  showQr: widget.showQr,
                )
              : Dismissible(
                  key: Key(widget.cardData.id.toString()),
                  direction: DismissDirection.horizontal,
                  confirmDismiss: (direction) async {
                    Completer<bool> res = Completer();
                    if (direction == DismissDirection.endToStart) {
                      final value = await removeCardFeature(context,
                          cardId: widget.cardData.id!,
                          cardName: widget.cardData.brandName, onRemove: () {
                        Navigator.pop(context);
                        sl<CardWalletPageBloc>().brandCardList.removeWhere(
                            (element) => element.id == widget.cardData.id);
                        sl<CardWalletPageBloc>()
                            .add(CardWalletInitializeEvent(context));
                        res.complete(true);
                      }, onNotRemove: () {
                        res.complete(false);
                      });
                    } else if (direction == DismissDirection.startToEnd) {
                      if (widget.ignore) res.complete(false);
                      Navigator.pushNamed(
                          context, AppRoutes.cardWallet.info.main,
                          arguments: CardWalletInfoPageArgs(
                              cardData: widget.cardData));
                      res.complete(false);
                    }
                    return res.future;
                  },
                  child: CustomCard(
                      isDetailsScreen: widget.isDetailsScreen,
                      cardData: widget.cardData,
                      ignore: widget.ignore,
                      user: widget.user,
                      userName: widget.userName,
                      showQr: widget.showQr),
                )),
    );
  }
}

class CustomCard extends StatelessWidget {
  final CardModel cardData;
  final String userName;
  final bool ignore;
  final UserModel? user;
  final bool isDetailsScreen;
  final bool showQr;

  const CustomCard(
      {super.key,
      required this.cardData,
      required this.userName,
      required this.ignore,
      this.user,
      required this.isDetailsScreen,
      required this.showQr});

  bool get isHushhIdCard => cardData.category == 'hushh_id_card';

  bool get isDemographicCard => cardData.category == 'pii_id_card';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (ignore) return;
        Navigator.pushNamed(context, AppRoutes.cardWallet.info.main,
            arguments: CardWalletInfoPageArgs(
                cardData: cardData,
                overrideAccess: user != null,
                customer: user != null
                    ? CustomerModel(brand: cardData, user: user!)
                    : null));
      },
      child: Container(
        width: 100.w - 32,
        height: preferenceCardHeight,
        decoration: BoxDecoration(
          // boxShadow: [
          //   BoxShadow(
          //       color: Colors.black38,
          //       blurRadius: 8,
          //       spreadRadius: 4
          //   )
          // ],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade800,
              offset: const Offset(1.0, 0.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
          color: cardData.bodyImage != null ? Colors.transparent : Colors.black,
          image: cardData.bodyImage != null
              ? DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(cardData.bodyImage!))
              : null,
        ),
        child: Stack(
          children: [
            if (!isHushhIdCard && !isDemographicCard)
              Container(
                width: 100.w - 32,
                height: preferenceCardHeight,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: const DecorationImage(
                        fit: BoxFit.fill,
                        opacity: .2,
                        image: AssetImage('assets/card_overlay.png'))),
              ),
            Positioned(
              top: 16,
              left: 24,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        cardData.id == Constants.businessCardId
                            ? (cardData.brandPreferences.firstOrNull
                                    ?.metadata?['answers']['business_name'] ??
                                "")
                            : cardData.brandName,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          shadows: [
                            BoxShadow(color: Colors.black87, blurRadius: 20)
                          ],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      if (cardData.id == Constants.businessCardId &&
                          cardData.brandPreferences.firstOrNull
                                  ?.metadata?['answers']['linkedin_verified'] ==
                              true) ...[
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 16,
                        )
                      ]
                    ],
                  ),
                  Text(userName,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          BoxShadow(color: Colors.black87, blurRadius: 14)
                        ],
                        fontSize: 18,
                      ))
                ],
              ),
            ),
            isDetailsScreen
                ? Positioned(
                    top: 14,
                    right: 24,
                    child: BlocBuilder(
                        bloc: sl<CardMarketBloc>(),
                        builder: (context, state) {
                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.cardMarketPlace.cardValue,
                                  arguments: CardValueArgs(
                                      cardData:
                                          sl<CardWalletPageBloc>().cardData!,
                                      editMode: true));
                            },
                            child: Text(
                              cardData.cardValue == '0'
                                  ? cardData.id == Constants.businessCardId
                                      ? ''
                                      : 'FREE'
                                  : (Utils().getCurrencyFromCurrencySymbol(
                                                  cardData.cardCurrency)
                                              ?.shorten() ??
                                          sl<HomePageBloc>()
                                              .currency
                                              .shorten()) +
                                      (cardData.cardValue ?? '0'),
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }),
                  )
                : const SizedBox(),
            if (showQr)
              Positioned(
                bottom: 16,
                right: 24,
                child: QrCodeWidget(brand: cardData),
              ),
            Positioned(
              bottom: 16 + 10,
              left: 24,
              child: CachedNetworkImage(
                imageUrl: cardData.logo,
                height: preferenceCardHeight * 0.1,
                width: 40.w,
                alignment: Alignment.bottomLeft,
              ),
            )
          ],
        ),
      ),
    );
  }
}
