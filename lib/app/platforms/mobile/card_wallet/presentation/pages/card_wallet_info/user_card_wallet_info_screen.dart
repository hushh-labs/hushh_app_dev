// app/platforms/mobile/card_wallet/presentation/pages/card_wallet_info/user_card_wallet_info_screen.dart
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/customer_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/shared_asset.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/inventory_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/lookbook_product_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/shared_assets_receipts_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/brand_card_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/card_wallet_info_card_widget.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/card_wallet_info_tab_bar.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/custom_card_wallet_info_floating_action_button.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/user_card_wallet_info_default_details_section.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/user_card_wallet_info_default_products_section.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/user_card_wallet_info_insurance_details_section.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/user_card_wallet_info_manage_section.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/user_card_wallet_info_uploads_section.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/agent_order_checkout.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/color_utils.dart';

class UserCardWalletInfoScreen extends StatefulWidget {
  final CardModel cardData;

  const UserCardWalletInfoScreen({super.key, required this.cardData});

  @override
  State<UserCardWalletInfoScreen> createState() =>
      _UserCardWalletInfoScreenState();
}

class _UserCardWalletInfoScreenState extends State<UserCardWalletInfoScreen> {
  final GlobalKey _globalKey = GlobalKey();
  final controller = sl<CardWalletPageBloc>();

  bool get isPreferenceCard => widget.cardData.isPreferenceCard;

  bool get isHushhIdOrDemographicCard =>
      isPreferenceCard &&
      (widget.cardData.category == 'hushh_id_card' ||
          widget.cardData.category == 'pii_id_card');

  @override
  void initState() {
    sl<CardWalletPageBloc>().cardData = widget.cardData;
    sl<CardWalletPageBloc>().audioNotesDuration = null;
    controller.cardKey = _globalKey;
    sl<LookBookProductBloc>().selectedProducts = [];
    sl<LookBookProductBloc>().inventoryAllProductsResult = null;
    sl<InventoryBloc>().cart.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.cardData.audioUrl != null &&
          widget.cardData.audioTranscription == null) {
        controller
            .add(GenerateAudioTranscriptionEvent(widget.cardData, context));
      }
      controller.add(FetchPurchasedItemsEvent());
      if (AppLocalStorage.hushhId != null &&
          widget.cardData.cid != null &&
          widget.cardData.id != null &&
          widget.cardData.brandId != null) {
        controller.add(FetchSharedPreferencesEvent(
            hushhId: AppLocalStorage.hushhId!, cardId: widget.cardData.id!));
        sl<LookBookProductBloc>()
            .add(FetchAllProductsEvent(widget.cardData.brandId!));
      }
    });
    super.initState();
  }

  List<SharedAsset>? get receiptAssets =>
      sl<SharedAssetsReceiptsBloc>().fileDataReceipts;

  @override
  Widget build(BuildContext context) {
    final isDark = ColorUtils.isDark(widget.cardData.primary);

    return Scaffold(
      backgroundColor: widget.cardData.secondary,
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        slivers: [
          SliverAppBar(
            pinned: true,
            // set however tall you want your top portion to be
            expandedHeight: cardHeight + kToolbarHeight + 16,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                sl<CardWalletPageBloc>().add(
                  CardWalletInitializeEvent(context, refresh: true),
                );
                Navigator.pop(context);
              },
              icon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_ios_new_sharp,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            centerTitle: false,
            actions: [
              Material(
                type: MaterialType.transparency,
                child: Ink(
                  decoration: BoxDecoration(
                    color: widget.cardData.primary,
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.black12,
                      width: 3.0,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: InkWell(
                      onTap: () {
                        sl<SharedAssetsReceiptsBloc>().add(
                          ShareCardImageEvent(widget.cardData, context),
                        );
                      },
                      borderRadius: BorderRadius.circular(100),
                      child: Icon(
                        Icons.share_outlined,
                        size: 20,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              BlocBuilder(
                bloc: sl<LookBookProductBloc>(),
                builder: (context, state) {
                  if (sl<LookBookProductBloc>()
                          .inventoryAllProductsResult
                          ?.products
                          .isEmpty ??
                      true) return const SizedBox();
                  return Row(
                    children: [
                      const SizedBox(width: 8),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Material(
                            type: MaterialType.transparency,
                            child: Ink(
                              decoration: BoxDecoration(
                                color: widget.cardData.secondary,
                                border: Border.all(
                                  color:
                                      isDark ? Colors.white12 : Colors.black12,
                                  width: 3.0,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: InkWell(
                                  onTap: () {
                                    final cart = sl<InventoryBloc>().cart;
                                    final allProducts =
                                        sl<LookBookProductBloc>()
                                                .inventoryAllProductsResult
                                                ?.products ??
                                            [];
                                    final filteredProducts =
                                        allProducts.expand((product) {
                                      final count =
                                          cart[product.productSkuUniqueId] ?? 0;
                                      return List.generate(
                                          count, (_) => product);
                                    }).toList();
                                    print(filteredProducts.length);
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.agentOrderCheckout,
                                      arguments: AgentOrderCheckoutArgs(
                                          products: filteredProducts,
                                          customerModel: CustomerModel(
                                              brand: widget.cardData,
                                              user: AppLocalStorage.user!)),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(100),
                                  child: Icon(
                                    Icons.shopping_cart_outlined,
                                    size: 20,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          BlocBuilder(
                            bloc: sl<InventoryBloc>(),
                            builder: (context, state) {
                              if (sl<InventoryBloc>().cart.values.sum.toInt() !=
                                  0) {
                                return Positioned(
                                  bottom: 10,
                                  right: -10,
                                  child: BlocBuilder(
                                    bloc: sl<InventoryBloc>(),
                                    builder: (context, state) {
                                      return CircleAvatar(
                                        radius: 12,
                                        backgroundColor:
                                            widget.cardData.secondary,
                                        child: Text(
                                          sl<InventoryBloc>()
                                              .cart
                                              .values
                                              .sum
                                              .toInt()
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          )
                        ],
                      )
                    ],
                  );
                },
              ),
              const SizedBox(width: 16),
            ],

            /// The main collapsing content
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 72, bottom: 16),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: const Alignment(-0.00, -1.00),
                    end: const Alignment(0, 1),
                    colors: [
                      widget.cardData.primary,
                      widget.cardData.secondary
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: kToolbarHeight),

                      /// The card itself. Adjust the padding/position as needed
                      CardWalletInfoCardWidget(cardData: widget.cardData),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              // your original white background & rounded corners can be done here if desired
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  BlocBuilder(
                    bloc: sl<LookBookProductBloc>(),
                    builder: (context, state) {
                      // Decide which tabs to show
                      final bool hasInventory = !(sl<LookBookProductBloc>()
                              .inventoryAllProductsResult
                              ?.products
                              .isEmpty ??
                          true);
                      final tabs = hasInventory
                          ? const ['Store', 'More Info', 'Access']
                          : const ['Details', 'Receipts', 'Uploads', 'Access'];

                      return Column(
                        children: [
                          const SizedBox(height: 4),
                          // The custom tab bar
                          CardWalletInfoTabBar(
                            tabs: tabs,
                            onTabChanged: (index) {
                              setState(() {
                                controller.selectedCardWalletInfoTabIndex =
                                    index;
                              });
                            },
                          ),
                          SizedBox(
                              height:
                                  widget.cardData.id == Constants.appUsageCardId
                                      ? 8
                                      : 16),
                        ],
                      );
                    },
                  ),
                  BlocBuilder(
                    bloc: sl<LookBookProductBloc>(),
                    builder: (context, state) {
                      final productResult =
                          sl<LookBookProductBloc>().inventoryAllProductsResult;
                      // The 4 possible sections you had in your array
                      final List<Widget> pages = [
                        if (widget.cardData.id == Constants.insuranceCardId)
                          UserCardWalletInfoInsuranceDetailsSection(
                              cardData: widget.cardData)
                        else if (productResult?.products.isEmpty ?? true)
                          UserCardWalletInfoDefaultDetailsSection(
                              cardData: widget.cardData)
                        else
                          UserCardWalletInfoDefaultProductsSection(
                              productResult: productResult!),

                        // "Receipts" or second section
                        if (productResult?.products.isEmpty ?? true)
                          UserCardWalletInfoUploadsSection(
                              cardData: widget.cardData)
                        else
                          UserCardWalletInfoDefaultDetailsSection(
                              cardData: widget.cardData),

                        // "Access" or third/fourth sections, etc.
                        UserCardWalletInfoManageSection(
                            cardData: widget.cardData),
                      ];

                      // Safely handle index out of range if your tab array differs in length
                      final currentIndex =
                          controller.selectedCardWalletInfoTabIndex;
                      final Widget currentPage = currentIndex < pages.length
                          ? pages[currentIndex]
                          : Container();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          currentPage,
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomCardWalletInfoFloatingActionButton(
        cardData: widget.cardData,
      ),
    );
  }
}

class CustomFloatingActionButton extends StatelessWidget {
  final List<String> tabs;
  final Function(int) onTap;
  final Color primary;

  const CustomFloatingActionButton(
      {super.key,
      required this.tabs,
      required this.onTap,
      required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
            tabs.length,
            (index) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                        onTap: () => onTap(index), child: Text(tabs[index])),
                    if (index != tabs.length - 1)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        height: 10,
                        width: 1,
                        color: Colors.black54,
                      )
                  ],
                )),
      ),
    );
  }
}
