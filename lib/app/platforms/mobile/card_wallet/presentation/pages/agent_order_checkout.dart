import 'dart:io';

import 'package:hushh_app/currency_converter/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/components/verifying_bottomsheet.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/customer_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/lookbook_product_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/agent_payment_request_sent_bottom_sheet.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/agent_update_bid_value_bottom_sheet.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/bloc/chat_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/components/payment_methods.dart';
import 'package:hushh_app/app/shared/core/components/shimmer_arrows.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/models/payment_model.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../currency_converter/currency_converter.dart';

class AgentOrderCheckoutArgs {
  final List<AgentProductModel> products;
  final CustomerModel customerModel;

  AgentOrderCheckoutArgs({required this.products, required this.customerModel});
}

class AgentOrderCheckout extends StatefulWidget {
  const AgentOrderCheckout({Key? key}) : super(key: key);

  @override
  State<AgentOrderCheckout> createState() => _AgentOrderCheckoutState();
}

class _AgentOrderCheckoutState extends State<AgentOrderCheckout> {
  double cardValue = 0;
  Currency? cardCurrency;
  bool isBottomSheetOpened = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final args = (ModalRoute.of(context)!.settings.arguments!
          as AgentOrderCheckoutArgs);
      final cardData = args.customerModel.brand;
      cardValue = (int.tryParse(cardData.cardValue ?? '') ?? 0).toDouble();
      cardCurrency = Utils()
          .getCurrencyFromCurrencySymbol(cardData.cardCurrency?.toUpperCase());
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        (ModalRoute.of(context)!.settings.arguments! as AgentOrderCheckoutArgs);

    double calculateSubtotal(List<AgentProductModel> products) {
      return products.map((e) => e.productPrice).reduce((a, b) => a + b);
    }

    Future<double> calculateTotalAmount() async {
      final subtotal = calculateSubtotal(args.products);
      final productCurrency = args.products.first.productCurrency;

      if (cardCurrency?.name.toLowerCase() == productCurrency.toLowerCase()) {
        return subtotal - cardValue;
      } else {
        final convertedAmount = await CurrencyConverter.convert(
          from: cardCurrency!,
          to: Utils().getCurrencyFromCurrencySymbol(productCurrency)!,
          amount: cardValue,
        );
        if (convertedAmount != null) {
          return subtotal - convertedAmount;
        } else {
          return subtotal;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: SvgPicture.asset('assets/back.svg')),
        ),
        centerTitle: false,
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: args.products.length,
                itemBuilder: (context, index) {
                  final product = args.products[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Image.network(
                          product.productImage,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.productName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product.productSkuUniqueId,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${Utils().getCurrencyFromCurrencySymbol(product.productCurrency)?.shorten()} ${product.productPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  KeyValueRow(
                    keyText: 'Shipping method',
                    valueText: sl<HomePageBloc>().isUserFlow
                        ? 'Online'
                        : 'In-store Purchase',
                  ),
                  const SizedBox(height: 16),
                  KeyValueRow(
                    keyText: 'Subtotal',
                    valueText:
                        '${Utils().getCurrencyFromCurrencySymbol(args.products.first.productCurrency)?.shorten()} ${calculateSubtotal(args.products).toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 16),
                  KeyValueRow(
                      keyText: 'Hushh discount 🤫',
                      valueText: '-${cardCurrency?.shorten()}${cardValue.toStringAsFixed(2)}',
                      onTap: sl<HomePageBloc>().isUserFlow
                          ? () {}
                          : () => editCardDiscount(context),
                      trailing: sl<HomePageBloc>().isUserFlow
                          ? null
                          : const Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Icon(
                                Icons.edit_outlined,
                                size: 16,
                              ),
                            )),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => editCardDiscount(context),
                    child: Text(
                      sl<HomePageBloc>().isUserFlow
                          ? 'Your card will be shared with the brand and the Sales Agent for future transactions and ease'
                          : 'User card will be unlocked and the information will be shared with Sales Agent.',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<double>(
                    future: calculateTotalAmount(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          children: [
                            const KeyValueRow(
                              keyText: 'Total',
                              valueText: 'Calculating...',
                            ),
                            const SizedBox(height: 16),
                            HushhLinearGradientButton(
                              text: sl<HomePageBloc>().isUserFlow
                                  ? 'Complete Payment'
                                  : 'Send Payment Request',
                              height: 46,
                              color: Colors.black,
                              trailing: true,
                              trailingWidget: const Padding(
                                padding: EdgeInsets.only(right: 20.0),
                                child: ShimmerArrows(),
                              ),
                              radius: 6,
                              onTap: () {},
                            ),
                            SizedBox(height: Platform.isIOS ? 16 : 0)
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return const KeyValueRow(
                          keyText: 'Total',
                          valueText: 'Error calculating total',
                        );
                      } else {
                        return Column(
                          children: [
                            KeyValueRow(
                              keyText: 'Total',
                              valueText:
                                  '${Utils().getCurrencyFromCurrencySymbol(args.products.first.productCurrency)?.shorten()} ${snapshot.data!.toStringAsFixed(2)}',
                            ),
                            const SizedBox(height: 16),
                            HushhLinearGradientButton(
                              text: sl<HomePageBloc>().isUserFlow
                                  ? 'Complete Payment'
                                  : 'Send Payment Request',
                              height: 46,
                              color: Colors.black,
                              trailing: true,
                              trailingWidget: const Padding(
                                padding: EdgeInsets.only(right: 20.0),
                                child: ShimmerArrows(),
                              ),
                              radius: 6,
                              onTap: () async {
                                Future.delayed(const Duration(seconds: 4), () {
                                  if (isBottomSheetOpened) {
                                    String currency = Utils()
                                        .getCurrencyFromCurrencySymbol(args
                                            .products.first.productCurrency)!
                                        .name
                                        .toUpperCase();
                                    String paymentId = const Uuid().v4();
                                    Navigator.pop(context);
                                    if (sl<HomePageBloc>().isUserFlow) {
                                      final myUser = types.User(
                                          id: sl<CardWalletPageBloc>()
                                              .cardData!
                                              .brandId!
                                              .toString(),
                                          imageUrl: sl<CardWalletPageBloc>()
                                              .cardData!
                                              .image,
                                          firstName: sl<CardWalletPageBloc>()
                                              .cardData!
                                              .brandName);
                                      final paymentModel = PaymentModel(
                                          id: paymentId,
                                          initiatedBrandId:
                                              sl<CardWalletPageBloc>()
                                                  .cardData!
                                                  .brandId!,
                                          toUuid:
                                              args.customerModel.user.hushhId!,
                                          image: "",
                                          currency: currency,
                                          status: PaymentStatus.pending,
                                          amountRaised: snapshot.data ?? 0,
                                          title: 'Dior Order: Payment Request',
                                          sharedCardId:
                                              args.customerModel.brand.cid,
                                          shareInfoAfterPaymentWithInitiatedUuid:
                                              true);
                                      sl<LookBookProductBloc>()
                                          .add(SendPaymentRequestToUserEvent(
                                        context: context,
                                        myUser: myUser,
                                        customerId:
                                            args.customerModel.user.hushhId!,
                                        otherUserAvatar: myUser.imageUrl,
                                        otherUserName: myUser.firstName,
                                        // agent: AppLocalStorage.agent!,
                                        paymentModel: paymentModel,
                                      ));
                                      // Navigator.pop(context);
                                      // Navigator.pop(context);
                                      // Navigator.pushNamed(context,
                                      //     AppRoutes.shared.paymentMethodsViewer,
                                      //     arguments: PaymentMethodsArgs(
                                      //       amount: paymentModel.amountRaised,
                                      //       currency: Utils()
                                      //           .getCurrencyFromCurrencySymbol(
                                      //               args.products.first
                                      //                   .productCurrency)!,
                                      //       description: "Payment request",
                                      //       onPaymentDone: () async {
                                      //         paymentModel.status =
                                      //             PaymentStatus.accepted;
                                      //         sl<ChatPageBloc>().add(
                                      //             PaymentStatusUpdateEvent(
                                      //                 paymentModel:
                                      //                     paymentModel.copyWith(
                                      //                         amountPayed:
                                      //                             paymentModel
                                      //                                 .amountRaised,
                                      //                         status: PaymentStatus
                                      //                             .accepted)));
                                      //         ToastManager(Toast(
                                      //                 title:
                                      //                     'Transaction success!'))
                                      //             .show(navigatorKey
                                      //                 .currentState!.context);
                                      //       },
                                      //       onPaymentFailed: () {
                                      //         ToastManager(Toast(
                                      //                 title:
                                      //                     'Transaction failed!',
                                      //                 type: ToastificationType
                                      //                     .error))
                                      //             .show(navigatorKey
                                      //                 .currentState!.context);
                                      //       },
                                      //     ));
                                    } else {
                                      showModalBottomSheet(
                                          context: context,
                                          isDismissible: true,
                                          enableDrag: true,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) =>
                                              AgentPaymentRequestSentBottomSheet(
                                                currency: currency,
                                                pId: paymentId,
                                                amount: snapshot.data!,
                                              ));
                                      final myUser = types.User(
                                          id: AppLocalStorage.hushhId!,
                                          firstName: AppLocalStorage
                                              .agent!.agentName!);
                                      final paymentModel = PaymentModel(
                                          id: paymentId,
                                          initiatedUuid: myUser.id,
                                          toUuid:
                                              args.customerModel.user.hushhId!,
                                          image: "",
                                          currency: currency,
                                          status: PaymentStatus.pending,
                                          amountRaised: snapshot.data ?? 0,
                                          title: 'Dior Order: Payment Request',
                                          sharedCardId:
                                              args.customerModel.brand.cid,
                                          shareInfoAfterPaymentWithInitiatedUuid:
                                              true);
                                      sl<LookBookProductBloc>()
                                          .add(SendPaymentRequestToUserEvent(
                                        context: context,
                                        myUser: myUser,
                                        customerId:
                                            args.customerModel.user.hushhId!,
                                        // agent: AppLocalStorage.agent!,
                                        paymentModel: paymentModel,
                                      ));
                                    }
                                  }
                                });
                                isBottomSheetOpened = true;
                                await showModalBottomSheet(
                                    context: context,
                                    isDismissible: false,
                                    enableDrag: false,
                                    backgroundColor: Colors.transparent,
                                    constraints:
                                        BoxConstraints(maxHeight: 30.h),
                                    builder: (context) =>
                                        const VerifyingBottomSheet(
                                            checkout: true));
                                isBottomSheetOpened = false;
                              },
                            ),
                            SizedBox(height: Platform.isIOS ? 16 : 0)
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> editCardDiscount(BuildContext context) async {
    // final args =
    //     (ModalRoute.of(context)!.settings.arguments! as AgentOrderCheckoutArgs);
    final value = await showModalBottomSheet(
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(maxHeight: 46.h),
      context: context,
      builder: (BuildContext context) => AgentUpdateBidValueBottomSheet(
        currentValue: cardValue,
        currency: cardCurrency!,
        maxValue: (10 / 100 * cardValue) + cardValue,
        minValue: cardValue - (10 / 100 * cardValue),
      ),
    );
    if (value != null) {
      cardValue = value;
      setState(() {});
    }
  }
}

class KeyValueRow extends StatelessWidget {
  final String keyText;
  final String valueText;
  final Widget? trailing;
  final Function()? onTap;

  const KeyValueRow({
    Key? key,
    required this.keyText,
    required this.valueText,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            keyText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            valueText,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          if (trailing != null) trailing!
        ],
      ),
    );
  }
}
