import 'dart:async';
import 'dart:io';

import 'package:hushh_app/currency_converter/currency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/pages/new/user_guide/user_guide.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/customer_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/user_request.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/agent_card_wallet_ai_summary.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/brand_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/card_questions_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/health_card_data.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/user_basic_info_header_section.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/agent_products.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/card_wallet_info/shared_assets_receipts.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/pages/receipt_radar_insights/receipt_radar_insights.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/ai_handler/ai_handler.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/components/hushh_secondary_button.dart';
import 'package:hushh_app/app/shared/core/components/payment_methods.dart';
import 'package:hushh_app/app/shared/core/firebase_config/firebase_remote_config_service.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

class AgentCardWalletInfoPage extends StatefulWidget {
  final CustomerModel customer;
  final bool overrideAccess;
  final UserRequest? userRequest;

  const AgentCardWalletInfoPage(
      {super.key,
      required this.customer,
      required this.overrideAccess,
      this.userRequest});

  @override
  State<AgentCardWalletInfoPage> createState() =>
      _AgentCardWalletInfoPageState();
}

class _AgentCardWalletInfoPageState extends State<AgentCardWalletInfoPage> {
  final controller = sl<AgentCardWalletPageBloc>();
  late double cardValue;

  bool get haveAccess =>
      ((widget.customer.brand.accessList ?? [])
          .contains(AppLocalStorage.hushhId)) ||
      widget.overrideAccess ||
      widget.customer.brand.cardValue == '0';

  CardModel get cardData => widget.customer.brand;

  StreamController<String> _streamController = StreamController<String>();
  String aiSummary = "";

  @override
  void initState() {
    final cardData = widget.customer.brand;
    cardValue = (int.tryParse(cardData.cardValue ?? '') ?? 0).toDouble();
    sl<CardWalletPageBloc>().cardData = cardData;
    controller.attachedCards = null;
    print(cardData.toJson());
    controller.add(FetchAttachedCardsEvent(cardData.cid));
    if (widget.userRequest != null) {
      controller.add(FetchUserRequestAgainstBrand(
          widget.userRequest!.userId, widget.userRequest!.brandId));
    }
    if (!haveAccess) {
      _fetchAndStreamSummary();
    }
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Stream<String> addDelay(Stream<String> input) async* {
    Duration dur = const Duration(milliseconds: 60);
    await Future.delayed(dur);
    await for (var event in input) {
      yield event;
      await Future.delayed(dur);
    }
  }

  void _fetchAndStreamSummary() async {
    // Simulate streaming response
    final stream = AiSummaryHandler().getChatResponseStream(
        context,
        cardData.id!,
        widget.customer.user.name,
        cardData.brandName,
        widget.customer.user.hushhId!);
    addDelay(stream).listen(
      (event) {
        if (mounted) {
          setState(() {
            try {
              final parsedEvent = event;
              aiSummary += parsedEvent;
              _streamController.add(aiSummary);
            } catch (_) {}
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.customer.brand.toJson());
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: kIsWeb
            ? BottomAppBar(
                color: Colors.blue,
                height: 46,
                padding: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 4, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                          child: Text(
                        'Download the Hushh app now 🎉',
                        style: TextStyle(color: Colors.white),
                      )),
                      OutlinedButton(
                        onPressed: () {
                          if (defaultTargetPlatform == TargetPlatform.macOS ||
                              defaultTargetPlatform == TargetPlatform.iOS) {
                            launchUrl(Uri.parse(
                                FirebaseRemoteConfigService().iosLink));
                          } else {
                            launchUrl(Uri.parse(
                                FirebaseRemoteConfigService().androidLink));
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(
                              color: Colors.white), // Border color
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 3),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(25.0), // Rounded corners
                          ),
                        ),
                        child: const Text(
                          'Download Now',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : null,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0)
              .copyWith(bottom: Platform.isIOS ? 24 : 16),
          child: AppLocalStorage.hushhId == null
              ? Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HushhLinearGradientButton(
                        text: 'Complete profile',
                        height: 46,
                        color: Colors.black,
                        radius: 6,
                        onTap: () async {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child: const UserGuidePage()));
                        },
                      ),
                      const Center(
                          child: Text(
                        'To unlock more features, complete your profile!',
                        textAlign: TextAlign.center,
                      ))
                    ],
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: HushhSecondaryButton(
                        text: 'Unlock Card',
                        height: 46,
                        color: Colors.white,
                        onTap: () {
                          onUnlockClicked(
                              context, cardValue, controller, cardData);
                        },
                        radius: 6,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: HushhLinearGradientButton(
                        text: 'Create Order',
                        height: 46,
                        color: Colors.black,
                        radius: 6,
                        onTap: () async {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.agentProducts,
                            arguments: AgentProductsArgs(
                                productTileType: ProductTileType.selectProducts,
                                brandId: AppLocalStorage.agent!.agentBrandId,
                                customer: widget.customer),
                          );
                        },
                      ),
                    )
                  ],
                ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              UserBasicInfoHeaderSection(
                customer: widget.customer,
                haveAccess: haveAccess,
              ),
              const SizedBox(height: 20),
              if (haveAccess) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoutes.receiptRadar.insights,
                                arguments: ReceiptRadarInsightsArgs(
                                    uid: widget.customer.user.hushhId!,
                                    brand: widget.customer.brand,
                                    cardData: cardData,
                                    customer: widget.customer,
                                    brandName: widget.customer.brand.brandName,
                                    brandCategory:
                                        widget.customer.brand.brandCategory));
                          },
                          child: Container(
                            height: 50,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment(-1.00, 0.05),
                                end: Alignment(1, -0.05),
                                colors: [Color(0xFFE54D60), Color(0xFFA342FF)],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.69),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 21,
                                  height: 24,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(),
                                  child: SvgPicture.asset(
                                    "assets/star-icon.svg",
                                    height: 24,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "AI Insights",
                                  style: context.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context,
                                AppRoutes.cardWallet.info.sharedAgentAssets,
                                arguments: SharedAssetsReceiptsPageArgs(
                                    cardData: cardData,
                                    customerModel: widget.customer,
                                    uid: widget.customer.user.hushhId!));
                          },
                          child: Container(
                            height: 50,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.69),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "View Vibes",
                                style: context.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'preferences and needs'.toUpperCase(),
                      style: context.titleSmall?.copyWith(
                        color: const Color(0xFF737373),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.3,
                      ),
                    ),
                  ),
                ),
                if (cardData.brandPreferences.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: cardData.id == Constants.healthCardId
                        ? const HealthInsights()
                        : const CardQuestionsListView(removeTitle: true),
                  ),
                  BlocBuilder(
                    bloc: sl<AgentCardWalletPageBloc>(),
                    builder: (context, state) {
                      final attachedCards = controller.attachedCards;
                      if (attachedCards?.isNotEmpty ?? false) {
                        return Column(
                          children: [
                            const SizedBox(height: 26),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'More info',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: CupertinoColors.black),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  BrandListView(
                                    customer: widget.customer,
                                    brands: attachedCards!,
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  const SizedBox(height: 26),
                ]
              ] else ...[
                StreamBuilder<String>(
                    stream: _streamController.stream,
                    builder: (context, snapshot) {
                      return AgentCardWalletAiSummary(content: snapshot.data);
                    }),
                const SizedBox(height: 64),
              ]
            ],
          ),
        ),
      ),
    );
  }

  onUnlockClicked(BuildContext context, double cardValue,
      AgentCardWalletPageBloc controller, CardModel cardData) async {
    Navigator.pushNamed(context, AppRoutes.shared.paymentMethodsViewer,
        arguments: PaymentMethodsArgs(
          amount: cardValue,
          currency:
              Utils().getCurrencyFromCurrencySymbol(cardData.cardCurrency) ??
                  Currency.usd,
          description: "${widget.customer.user.name}'s card details",
          onPaymentDone: () async {
            controller.add(OnSuccessCardUnlockEvent(
                context: context,
                cardData: cardData,
                customer: widget.customer,
                cardInfoUnlockMethod: CardInfoUnlockMethod.byAgent));
          },
          onPaymentFailed: () {
            ToastManager(Toast(
                    title: 'Transaction failed!',
                    notification: CustomNotification(
                      title: 'Payment Failed!',
                      description:
                          'Payment for ${widget.customer.user.name}\'s card details failed! Please try again',
                    ),
                    type: ToastificationType.error))
                .show(context);
          },
        ));
  }
}

// onUnlockClicked(context, cardValue, controller, cardData)
