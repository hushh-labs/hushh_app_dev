import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/models/transaction_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/insurance_receipt.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/health_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/app_usage_insights.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/brand_card_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/brand_tab_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/card_wallet_section.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/cards_for_you_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/custom_card_wallet_tab_bar.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/general_tab_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/health_card_data.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/link_receipt_radar_mission_card.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/loader_widget.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/make_your_own_brand_card_banner.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/preference_card_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/transactions_mini_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/travel_insights.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/user_card_wallet_info_insurance_policy_details_component.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/user_qr_scan_bottom_sheet.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/wallet_app_bar.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/card_wallet_info/card_wallet_info.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/bloc/receipt_radar_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/pages/receipt_radar_insights/insights_components.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/bloc/settings_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/backend_controller/db_controller/db_tables.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/tutorial_helper.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CardWalletPage extends StatefulWidget {
  const CardWalletPage({super.key});

  @override
  State<CardWalletPage> createState() => _CardWalletPageState();
}

class _CardWalletPageState extends State<CardWalletPage>
    with SingleTickerProviderStateMixin {
  final controller = sl<CardWalletPageBloc>();
  late StreamSubscription<List<Map<String, dynamic>>> streamSubscription;
  late Stream<List<TransactionModel>> transactionStream;
  final gKeyCards = GlobalKey(debugLabel: 'card_list_view');
  final gKeyMarketplace = GlobalKey(debugLabel: 'card_marketplace');
  final gKeyReceiptRadar = GlobalKey(debugLabel: 'receipt_radar_section');
  final gKeyTransactions = GlobalKey(debugLabel: 'transactions_section');
  final gKeyHealth = GlobalKey(debugLabel: 'health_section');
  final gKeyTravel = GlobalKey(debugLabel: 'travel_section');
  final gKeyInsurance = GlobalKey(debugLabel: 'insurance_section');

  @override
  void initState() {
    controller.tabController = TabController(
        length: 2,
        vsync: this,
        initialIndex: controller.brandCardList.isEmpty ? 1 : 0);
    controller.tabController!.addListener(() {
      setState(() {});
    });
    streamSubscription = Supabase.instance.client
        .from(DbTables.receiptRadarHistory)
        .stream(primaryKey: ['id']).listen((state) {
      Map<String, dynamic>? row = state
          .where((element) =>
              element['id'].toString() == AppLocalStorage.receiptRadarSessionId)
          .firstOrNull;
      if (row?['status'] == 'completed') {
        AppLocalStorage.setSessionIdForReceiptRadar(null);
        setState(() {});
      }
    });

    transactionStream = controller.getTransactionsStream().asBroadcastStream();
    super.initState();
  }

  @override
  void dispose() {
    controller.tabController!.dispose();
    streamSubscription.cancel();
    super.dispose();
  }

  InsuranceReceipt? get insuranceReceipt =>
      controller.insuranceReceipts?.elementAtOrNull(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WalletAppBar(setState: setState),
      body: BlocConsumer(
        bloc: controller,
        listener: (context, state) {
          if (state is InitializedState) {
            if (!AppLocalStorage.isTutorialWatched) {
              Future.delayed(const Duration(seconds: 0), () {
                if (!TutorialHelper().isStarted) {
                  // TutorialHelper().startTutorial(context,
                  //     scrollController: controller.scrollController);
                }
              });
            }
          }
        },
        builder: (context, state) {
          print(
              "StatebrandCardList.length:::$state && ${controller.preferenceCards.length}");
          return state is InitializingState
              ? const LoaderWidget()
              : SingleChildScrollView(
                  controller: controller.scrollController,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      if (controller.brandCardList.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: CustomCardWalletTabBar(
                            tabController: controller.tabController!,
                            onValueChanged: (value) {
                              if (value != null) {
                                controller.tabController!.animateTo(value);
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      SizedBox(
                        height: preferenceCardHeight,
                        width: 100.w,
                        child: TabBarView(
                          controller: controller.tabController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: const [BrandTabView(), GeneralTabView()],
                        ).withTutorial(
                          context: context,
                          gkey: gKeyCards,
                          contents: [
                            const Text(
                              "Your cards are all stacked into one place for you  to easily help manage your data, you can tap on the card to view the data and update your preferences.",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                          priority: 0,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const AddBrandCardBanner().withTutorial(
                        context: context,
                        gkey: gKeyMarketplace,
                        contents: [
                          const Text(
                            "you can go to the card marketplace to create your favourite brands card or you can create cards based on your preferences like coffee and fashion ! ",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                        priority: 1,
                      ),
                      const SizedBox(height: 24),
                      if (controller.recommendedCards?.isNotEmpty ?? false) ...[
                        const CardWalletSection(
                            title: 'cards for you',
                            child: CardsForYouListView()),
                        const SizedBox(height: 24),
                      ],
                      BlocBuilder(
                          bloc: sl<ReceiptRadarBloc>(),
                          builder: (context, state) {
                            return sl<ReceiptRadarBloc>().categories.isEmpty
                                ? const SizedBox()
                                : CardWalletSection(
                                    title: 'receipt radar',
                                    sideComponent: GestureDetector(
                                      onTap: () {
                                        openGeneralCard(
                                            Constants.expenseCardId);
                                      },
                                      child: const Text(
                                        'view more',
                                        style: TextStyle(
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        openGeneralCard(
                                            Constants.expenseCardId);
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: IgnorePointer(
                                          ignoring: true,
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 8),
                                              CategoryPieChart(
                                                fromHome: true,
                                                categories:
                                                    sl<ReceiptRadarBloc>()
                                                        .categories
                                                        .sorted((a, b) =>
                                                            b.amount.compareTo(
                                                                a.amount))
                                                        .take(3)
                                                        .toList(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ).withTutorial(
                                    context: context,
                                    gkey: gKeyReceiptRadar,
                                    contents: [
                                      const Text(
                                        "Here you can see all your expenses in categories with just a glance you can learn which categories you have spent the most on tap on view more to check the details.",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                    priority: 2,
                                  );
                          }),
                      StreamBuilder<List<TransactionModel>>(
                          stream: transactionStream,
                          builder: (context, state) {
                            if (state.data != null) {
                              controller.transactions = state.data;
                            }
                            if (controller.transactions?.isNotEmpty ?? false) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24.0),
                                child: CardWalletSection(
                                    title: 'transactions',
                                    sideComponent: AppLocalStorage
                                            .isReceiptRadarFetchingReceipts
                                        ? const Row(
                                            children: [
                                              Text('Fetching...'),
                                              SizedBox(width: 4),
                                              CupertinoActivityIndicator(
                                                radius: 6,
                                              )
                                            ],
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              sl<HomePageBloc>().add(
                                                  UpdateHomeScreenIndexEvent(
                                                      1, context));
                                            },
                                            child: const Text(
                                              'see more',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                    child: TransactionsMiniView(
                                      transactions:
                                          state.data?.take(3).toList() ??
                                              controller.transactions ??
                                              [],
                                    )).withTutorial(
                                  context: context,
                                  gkey: gKeyTransactions,
                                  contents: [
                                    const Text(
                                      "You can see all your expenses here for each brand letting you understand your purchase habits and brand alignment better",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                  priority: 3,
                                ),
                              );
                            } else if (!AppLocalStorage
                                .hasUserConnectedReceiptRadar) {
                              return const LinkReceiptRadarMissionCard();
                            }
                            return const SizedBox();
                          }),
                      BlocBuilder(
                          bloc: sl<HealthBloc>(),
                          builder: (context, state) {
                            return CardWalletSection(
                                    title: 'health insight',
                                    sideComponent: Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              sl<HealthBloc>().add(
                                                  FetchHealthDataEvent(
                                                      refresh: true,
                                                      context: context));
                                            },
                                            icon: const Icon(Icons.refresh)),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () {
                                            openGeneralCard(
                                                Constants.healthCardId);
                                          },
                                          child: const Text(
                                            'see more',
                                            style: TextStyle(
                                                color: Colors.black,
                                                decoration:
                                                    TextDecoration.underline,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        )
                                      ],
                                    ),
                                    child: const HealthInsights())
                                .withTutorial(
                              context: context,
                              gkey: gKeyHealth,
                              contents: [
                                const Text(
                                  "Access health insights like your activity patterns, all in one organized view.",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                              priority: 4,
                            );
                          }),
                      const SizedBox(height: 24),
                      CardWalletSection(
                              title: 'travel insight',
                              sideComponent: GestureDetector(
                                onTap: () {
                                  openGeneralCard(Constants.travelCardId);
                                },
                                child: const Text(
                                  'see more',
                                  style: TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              child: const TravelInsights(fromHome: true))
                          .withTutorial(
                        context: context,
                        gkey: gKeyTravel,
                        contents: [
                          const Text(
                            "Here you can see all the place you have travelled to this year . you can tap on the view all button to see more details about your travels this year",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                        priority: 5,
                      ),
                      if (insuranceReceipt != null) ...[
                        const SizedBox(height: 24),
                        CardWalletSection(
                            title: 'insurance insight',
                            sideComponent: GestureDetector(
                              onTap: () {
                                openGeneralCard(Constants.insuranceCardId);
                              },
                              child: const Text(
                                'see more',
                                style: TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child:
                                  UserCardWalletInfoInsurancePolicyDetailsComponent(
                                      receipt: insuranceReceipt,
                                      fromHome: true),
                            ))
                      ],
                      const SizedBox(height: 24),
                      // BlocBuilder(
                      //   bloc: sl<SettingsPageBloc>(),
                      //   builder: (context, state) {
                      //     if (sl<SettingsPageBloc>().collections?.isNotEmpty ??
                      //         false) {
                      //       return Column(
                      //         children: [
                      //           CardWalletSection(
                      //               title: 'your wishlist',
                      //               child: Padding(
                      //                 padding: const EdgeInsets.symmetric(
                      //                     horizontal: 16.0),
                      //                 child: WishlistListView(
                      //                     collections: sl<SettingsPageBloc>()
                      //                         .collections!),
                      //               )),
                      //           const SizedBox(height: 24),
                      //         ],
                      //       );
                      //     }
                      //     if (!(AppLocalStorage.user?.isHushhExtensionUser ??
                      //         false)) {
                      //       return const Padding(
                      //         padding: EdgeInsets.only(bottom: 24.0),
                      //         child: BrowsingCompanionMissionCard(),
                      //       );
                      //     }
                      //     return const SizedBox();
                      //   },
                      // ),
                      BlocBuilder(
                          bloc: sl<SettingsPageBloc>(),
                          builder: (context, state) {
                            if (Platform.isAndroid &&
                                (sl<SettingsPageBloc>().appUsage?.isNotEmpty ??
                                    false)) {
                              return CardWalletSection(
                                  title: 'app usage insight',
                                  child: AppUsageInsightsComponent(
                                      fromHome: true));
                            }
                            return const SizedBox();
                          }),
                    ],
                  ),
                );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          shape: const CircleBorder(),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [
                  Color(0xFFE54D60),
                  Color(0xFFA342FF),
                ])),
            child: Image.asset('assets/scanner_icon.png'),
          ),
          onPressed: () {
            //sl<AgentCardWalletPageBloc>().add(FetchCardInfoEvent(userUid, brandId, context));
            showModalBottomSheet(
              backgroundColor: Colors.white,
              constraints: BoxConstraints(maxHeight: 70.h),
              context: context,
              isDismissible: true,
              builder: (context) => const UserQrScanBottomSheet(),
            );
          },
        ),
      ),
    );
  }

  openGeneralCard(int cardId) {
    final cardData = sl<CardWalletPageBloc>()
        .preferenceCards
        .firstWhereOrNull((element) => element.id == cardId);
    if (cardData != null) {
      Navigator.pushNamed(context, AppRoutes.cardWallet.info.main,
          arguments: CardWalletInfoPageArgs(cardData: cardData));
    } else {
      sl<CardWalletPageBloc>()
          .add(InstallCardFromMarketplaceEvent(cardId, context));
    }
  }
}
