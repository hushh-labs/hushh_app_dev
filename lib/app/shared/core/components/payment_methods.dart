import 'package:hushh_app/currency_converter/currency.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:pay/pay.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/hushh_meet_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/constants/payment_config.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/firebase_config/firebase_remote_config_service.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';

import 'package:razorpay_web/razorpay_web.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:tuple/tuple.dart';
import 'package:upi_india/upi_india.dart';
import 'package:uuid/uuid.dart';

import '../../../../currency_converter/currency_converter.dart';

class PaymentMethodsArgs {
  final double amount;
  final bool showHushhCoins;
  final Function() onPaymentDone;
  final Function() onPaymentFailed;
  final String description;
  final Currency currency;

  PaymentMethodsArgs({
    required this.amount,
    required this.description,
    required this.onPaymentDone,
    required this.onPaymentFailed,
    required this.currency,
    this.showHushhCoins = true,
  });
}

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  final UpiIndia _upiIndia = UpiIndia();
  late final Pay _payClient;

  List<UpiApp>? appMetaList;
  late List<Tuple4<String, IconData, PaymentMethods, Function()>>
      otherPaymentMethods;
  PaymentMethods? selectedPaymentMethod;
  UpiApp? selectedUpiPayment;


  @override
  void initState() {
    otherPaymentMethods = [
      Tuple4('Pay using USDC', Icons.account_tree_outlined, PaymentMethods.usdc,
          () {
        selectedPaymentMethod = PaymentMethods.usdc;
        setState(() {});
      }),
      if (!kIsWeb)
        Tuple4('Hushh Coins', Icons.attach_money, PaymentMethods.hushhCoins,
            () {
          selectedPaymentMethod = PaymentMethods.hushhCoins;
          setState(() {});
        }),
      Tuple4('Credit/debit Card', Icons.add_card_rounded, PaymentMethods.card,
          () {
        selectedPaymentMethod = PaymentMethods.card;
        setState(() {});
      }),
      Tuple4('Razorpay', Icons.account_balance, PaymentMethods.razorpay, () {
        selectedPaymentMethod = PaymentMethods.razorpay;
        setState(() {});
      }),
      if (!kIsWeb)
        Tuple4('Google Pay', Icons.payments, PaymentMethods.gPay, () {
          selectedPaymentMethod = PaymentMethods.gPay;
          setState(() {});
        }),

    ];
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final args =
          ModalRoute.of(context)!.settings.arguments as PaymentMethodsArgs;
      if (!args.showHushhCoins) {
        // remove hushh coins list tile
        otherPaymentMethods.removeAt(1);
        setState(() {});
      }
    });
    if (!kIsWeb) {
      getUpiApps();
    }
    super.initState();
  }

  getUpiApps() async {
    appMetaList = await _upiIndia.getAllUpiApps(mandatoryTransactionId: false);
    setState(() {});
  }

  Widget appWidget(UpiApp appMeta) {
    return GestureDetector(
      onTap: () {
        selectedPaymentMethod = PaymentMethods.upi;
        selectedUpiPayment = appMeta;
        setState(() {});
      },
      child: Container(
        decoration: selectedUpiPayment == appMeta &&
                selectedPaymentMethod == PaymentMethods.upi
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue, width: 2))
            : null,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.memory(
                  appMeta.icon,
                  width: 46,
                ), // Logo
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  alignment: Alignment.center,
                  child: Text(
                    appMeta.name,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            if (selectedUpiPayment == appMeta &&
                selectedPaymentMethod == PaymentMethods.upi)
              Positioned(
                bottom: -8,
                right: -8,
                child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(Icons.check_circle, color: Colors.blue)),
              )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as PaymentMethodsArgs;
    return DoubleBack(
      message: "Press back again to cancel the transaction",
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payment Methods'),
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                "${args.currency.shorten()} ${args.amount}",
                style: context.titleLarge,
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  if (appMetaList != null && appMetaList!.isNotEmpty) ...[
                    Text(
                      'Pay directly with your favourite UPI apps',
                      style: context.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    GridView.builder(
                        shrinkWrap: true,
                        itemCount: appMetaList!.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4),
                        itemBuilder: (context, index) =>
                            appWidget(appMetaList![index])),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Divider(),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Other Payments Methods',
                    style: context.titleMedium,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: otherPaymentMethods.length,
                    itemBuilder: (context, index) => otherPaymentMethod(
                      paymentMethod: otherPaymentMethods[index],
                    ),
                  )
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0)
                  .copyWith(bottom: 24),
              child: Opacity(
                opacity: selectedPaymentMethod != null ? 1 : 0.2,
                child: SlideAction(
                  height: 52,
                  text: 'swipe to complete transaction',
                  onSubmit: () async {
                    if (selectedPaymentMethod == PaymentMethods.upi) {
                      try {
                        var convertedAmount = await CurrencyConverter.convert(
                          from: Currency.usd,
                          to: Currency.inr,
                          amount: args.amount,
                        );
                        final response = await _upiIndia.startTransaction(
                          app: selectedUpiPayment!,
                          receiverUpiId:
                              FirebaseRemoteConfigService().hushhUpiId,
                          receiverName: 'Hushh Wallet',
                          transactionRefId: const Uuid().v4(),
                          transactionNote: args.description,
                          amount: convertedAmount!,
                        );
                        if (response.transactionId != null) {
                          args.onPaymentDone();
                          Navigator.pop(context);
                        } else {
                          args.onPaymentFailed();
                          Navigator.pop(context);
                        }
                      } catch (_) {
                        args.onPaymentFailed();
                        Navigator.pop(context);
                      }
                    } else if (selectedPaymentMethod == PaymentMethods.card) {
                      // Card payment functionality removed
                      // Use alternative payment methods like Razorpay or Google Pay
                      args.onPaymentFailed();
                      Navigator.pop(context);
                    } else if (selectedPaymentMethod == PaymentMethods.gPay) {
                      var convertedAmount = await CurrencyConverter.convert(
                        from: Currency.usd,
                        to: Currency.inr,
                        amount: args.amount,
                      );
                      _payClient = Pay({
                        PayProvider.google_pay:
                            PaymentConfiguration.fromJsonString(
                                defaultGooglePay),
                      });
                      final result = await _payClient.showPaymentSelector(
                        PayProvider.google_pay,
                        [
                          PaymentItem(
                            label: 'Total',
                            amount: '${convertedAmount! * 100}',
                            status: PaymentItemStatus.final_price,
                          )
                        ],
                      );
                    } else if (selectedPaymentMethod ==
                        PaymentMethods.razorpay) {
                      var convertedAmount = await CurrencyConverter.convert(
                        from: Currency.usd,
                        to: Currency.inr,
                        amount: args.amount,
                      );
                      await payment(convertedAmount!);


                    } else if (selectedPaymentMethod ==
                        PaymentMethods.hushhCoins) {
                      int coins = sl<CardWalletPageBloc>().isAgent
                          ? (AppLocalStorage.agent?.agentCoins ??
                              sl<CardWalletPageBloc>()
                                  .selectedAgent
                                  ?.agentCoins ??
                              0)
                          : 0;
                      final availableMoney = Utils().hushhCoinsToMoney(coins);
                      if (availableMoney >= args.amount) {
                        int moneyInCoins =
                            Utils().moneyToHushhCoinsInInt(args.amount);
                        sl<AgentCardWalletPageBloc>()
                            .updateCoins(moneyInCoins * -1);
                        await args.onPaymentDone();
                      }
                    }
                  },
                  sliderRotate: true,
                  submittedIcon: const Icon(Icons.check, color: Colors.white),
                  enabled: selectedPaymentMethod != null,
                  sliderButtonIcon: const Icon(Icons.keyboard_arrow_right,
                      color: Colors.blue),
                  textStyle: context.bodyLarge?.copyWith(color: Colors.white),
                  outerColor: Colors.blue,
                  sliderButtonIconPadding: 10,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  payment(double amount) async {
    void handlePaymentErrorResponse(PaymentFailureResponse response) {
      /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
      final args =
          ModalRoute.of(context)!.settings.arguments as PaymentMethodsArgs;
      args.onPaymentFailed();
    }

    void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
      final args =
          ModalRoute.of(context)!.settings.arguments as PaymentMethodsArgs;
      await args.onPaymentDone();
      /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    }

    void handleExternalWalletSelected(ExternalWalletResponse response) {
      showAlertDialog(
          context, "External Wallet Selected", "${response.walletName}");
    }

    final razorpay = Razorpay();
    var options = {
      'key': const String.fromEnvironment('razorpay_key'),
      'amount': (amount * 100).toInt(),
      'name': 'Hushh',
      'description': '',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '+916381980743', 'email': 'contact@hushh.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    razorpay.open(options);
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget otherPaymentMethod(
      {required Tuple4<String, IconData, PaymentMethods, Function()>
          paymentMethod}) {
    String title = paymentMethod.item1;
    IconData icon = paymentMethod.item2;
    PaymentMethods currentPaymentMethod = paymentMethod.item3;
    bool enabled = currentPaymentMethod != PaymentMethods.usdc;
    Function() onTap = paymentMethod.item4;
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: selectedPaymentMethod == currentPaymentMethod
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue, width: 2))
            : null,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(child: Icon(icon)),
            if (selectedPaymentMethod == currentPaymentMethod)
              Positioned(
                bottom: -10,
                right: -10,
                child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(Icons.check_circle, color: Colors.blue)),
              )
          ],
        ),
      ),
      title: Text(title),
      subtitle: currentPaymentMethod == PaymentMethods.usdc
          ? const Text("Connect your crypto wallet to use this payment method")
          : currentPaymentMethod == PaymentMethods.hushhCoins
              ? Text(
                  "Hushh Wallet Balance: ${sl<CardWalletPageBloc>().isAgent ? (AppLocalStorage.agent?.agentCoins ?? sl<CardWalletPageBloc>().selectedAgent?.agentCoins ?? '0') : '0'} coins")
              : null,
      enabled: enabled,
      onTap: onTap,
      trailing: const Icon(Icons.keyboard_arrow_right),
    );
  }
}
