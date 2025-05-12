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
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

double cardHeight = 25.h;

class BrandCardListView extends StatelessWidget {
  final UserModel? userModel;
  final bool isDetailsScreen;
  final Function()? onIndexChanged;

  const BrandCardListView(
      {super.key,
      required this.isDetailsScreen,
      this.userModel,
      this.onIndexChanged});

  @override
  Widget build(BuildContext context) {
    List<CardModel> brandCardList = sl<CardWalletPageBloc>().brandCardList;
    return SizedBox(
      height: cardHeight + 5,
      width: double.infinity,
      child: Swiper(
        itemWidth: 100.w - 32,
        itemHeight: cardHeight,
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
            tag: brandCardList[index].id!,
            child: BrandCardWidget(
              brand: brandCardList[index],
              user: userModel,
              showQr: showQr,
              index: index,
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

class BrandCardWidget extends StatelessWidget {
  final CardModel brand;
  final bool ignore;
  final bool isDetailsScreen;
  final bool isRecommendedCard;
  final UserModel? user;
  final bool showQr;
  final int? index;

  const BrandCardWidget({
    super.key,
    required this.brand,
    this.ignore = false,
    required this.isDetailsScreen,
    this.isRecommendedCard = false,
    this.user,
    this.showQr = true,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    double cardWidth = 100.w - 32;
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: isRecommendedCard ? cardWidth * 0.85 : cardWidth,
        key: Key(brand.id.toString()),
        height: isRecommendedCard ? cardHeight * 0.85 : cardHeight,
        child: ignore || isDetailsScreen || isRecommendedCard || true
            ? CustomCard(
                isDetailsScreen: isDetailsScreen,
                brand: brand,
                ignore: ignore,
                index: isRecommendedCard ? index! : 0,
                isRecommendedCard: isRecommendedCard,
                user: user,
                showQr: showQr,
              )
            : Dismissible(
                key: Key(brand.id.toString()),
                direction: DismissDirection.horizontal,
                confirmDismiss: (direction) async {
                  Completer<bool> res = Completer();
                  if (direction == DismissDirection.endToStart) {
                    final value = await removeCardFeature(context,
                        cardId: brand.id!,
                        cardName: brand.brandName, onRemove: () {
                      Navigator.pop(context);
                      sl<CardWalletPageBloc>()
                          .brandCardList
                          .removeWhere((element) => element.id == brand.id);
                      sl<CardWalletPageBloc>()
                          .add(CardWalletInitializeEvent(context));
                      res.complete(true);
                    }, onNotRemove: () {
                      res.complete(false);
                    });
                  } else if (direction == DismissDirection.startToEnd) {
                    if (ignore) res.complete(false);
                    Navigator.pushNamed(context, AppRoutes.cardWallet.info.main,
                        arguments: CardWalletInfoPageArgs(cardData: brand));
                    res.complete(false);
                  }
                  return res.future;
                },
                child: CustomCard(
                  isDetailsScreen: isDetailsScreen,
                  brand: brand,
                  ignore: ignore,
                  index: isRecommendedCard ? index! : 0,
                  isRecommendedCard: isRecommendedCard,
                  user: user,
                  showQr: showQr,
                ),
              ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final CardModel brand;
  final bool ignore;
  final bool isDetailsScreen;
  final bool isRecommendedCard;
  final UserModel? user;
  final bool showQr;
  final int index;

  const CustomCard(
      {super.key,
      required this.brand,
      required this.ignore,
      required this.isDetailsScreen,
      this.user,
      required this.showQr,
      required this.isRecommendedCard,
      required this.index});

  void onOpenCard(context) {
    if (isRecommendedCard) return;
    if (ignore) return;
    Navigator.pushNamed(context, AppRoutes.cardWallet.info.main,
        arguments: CardWalletInfoPageArgs(
            cardData: brand,
            overrideAccess: user != null,
            customer: user == null
                ? null
                : CustomerModel(user: user!, brand: brand)));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onOpenCard(context);
      },
      child: Container(
        width: 100.w - 32,
        height: cardHeight,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade800,
              offset: const Offset(1.0, 0.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
          color: brand.bodyImage != null
              ? null
              : isRecommendedCard &&
                      sl<CardWalletPageBloc>().recommendedCardsColors.isNotEmpty
                  ? sl<CardWalletPageBloc>().recommendedCardsColors[index]
                  : Colors.black,
          image: brand.bodyImage != null
              ? DecorationImage(
                  fit: BoxFit.fill,
                  image: CachedNetworkImageProvider(brand.bodyImage!,
                      errorListener: (_) {}),
                )
              : null,
        ),
        child: Stack(
          children: [
            if (!isRecommendedCard)
              Container(
                width: 100.w - 32,
                height: cardHeight,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/card_overlay.png'))),
              ),
            Positioned(
              top: 16,
              left: isRecommendedCard ? 12 : 24,
              child: Transform.scale(
                scale: isRecommendedCard ? 0.85 : 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isRecommendedCard
                          ? brand.brandName.capitalize()
                          : brand.brandName,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: isRecommendedCard &&
                                sl<CardWalletPageBloc>()
                                    .recommendedCardsColors
                                    .isNotEmpty
                            ? Utils().getTextColor(sl<CardWalletPageBloc>()
                                .recommendedCardsColors[index])
                            : Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(AppLocalStorage.user?.name ?? '',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: isRecommendedCard &&
                                  sl<CardWalletPageBloc>()
                                      .recommendedCardsColors
                                      .isNotEmpty
                              ? Utils().getTextColor(sl<CardWalletPageBloc>()
                                  .recommendedCardsColors[index])
                              : Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ))
                  ],
                ),
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
                              brand.cardValue == '0'
                                  ? 'FREE'
                                  : sl<HomePageBloc>().currency.shorten() +
                                      (brand.cardValue ?? '0'),
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
                : isRecommendedCard
                    ? Positioned(
                        top: 14,
                        right: isRecommendedCard ? 12 : 24,
                        child: Transform.scale(
                          scale: isRecommendedCard ? 0.85 : 1,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white),
                              onPressed: () {
                                CardModel card = brand.copyWith(
                                  installedTime: DateTime.now(),
                                  name: AppLocalStorage.user!.name,
                                  cardValue: "1",
                                  userId: AppLocalStorage.hushhId!,
                                  coins: "10"
                                );
                                sl<CardMarketBloc>()
                                    .add(InsertCardInUserInstalledCardsEvent(card, context));
                              },
                              child: Text(
                                'Create Card',
                                style: context.bodySmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              )),
                        ),
                      )
                    : const SizedBox(),
            if (showQr)
              Positioned(
                bottom: 14,
                right: isRecommendedCard ? 12 : 24,
                child: Transform.scale(
                    scale: isRecommendedCard ? 0.85 : 1,
                    child: QrCodeWidget(brand: brand)),
              ),
            Positioned(
              bottom: 14,
              left: isRecommendedCard ? 12 : 24,
              child: Transform.scale(
                scale: isRecommendedCard ? 0.85 : 1,
                child: CachedNetworkImage(
                  imageUrl: brand.logo,
                  height: cardHeight * 0.2,
                  width: 40.w,
                  errorWidget: (a, b, c) => const SizedBox(),
                  alignment: Alignment.bottomLeft,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
