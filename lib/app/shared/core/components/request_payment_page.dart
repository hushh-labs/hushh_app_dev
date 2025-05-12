import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/components/numeric_keyboard.dart';
import 'package:hushh_app/app/shared/core/components/payment_methods.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:toastification/toastification.dart';

class RequestPaymentPage extends StatefulWidget {
  const RequestPaymentPage({super.key});

  @override
  RequestPaymentPageState createState() => RequestPaymentPageState();
}

class RequestPaymentPageState extends State<RequestPaymentPage> {
  TextEditingController controller = TextEditingController();
  String text = '';

  @override
  void initState() {
    if (AppLocalStorage.agent != null) {
      sl<HomePageBloc>().updateLocation().then((value) {
        setState(() {});
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Recharge Wallet'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert_outlined),
            onSelected: (dynamic v) {},
            itemBuilder: (BuildContext context) {
              List<PopupMenuEntry<Object>> list = [];
              list.add(
                const PopupMenuItem(
                  value: 1,
                  child: Text("Send feedback"),
                ),
              );
              return list;
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: 100.h - kToolbarHeight - 42,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                  AppLocalStorage.agent!.agentImage!)),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 5),
                          CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(20),
                                child: Image.asset(
                                  "assets/hbot.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      BlocBuilder(
                        bloc: sl<AgentCardWalletPageBloc>(),
                        builder: (context, state) {
                          return Text(
                            '${sl<HomePageBloc>().currency?.shorten()} ${text.isEmpty ? '0.00' : '$text.00'}',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'You\'ll be receiving ${Utils().moneyToHushhCoins(
                          text.isEmpty ? '0.00' : '$text.00',
                        )} Hushh coins 🎉',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Opacity(
                      opacity: text.isNotEmpty ? 1 : 0.2,
                      child: SlideAction(
                        height: 52,
                        text: 'Recharge Hushh wallet',
                        onSubmit: () async {
                          await Future.delayed(const Duration(seconds: 1));
                          // ignore: use_build_context_synchronously
                          Navigator.pushNamed(
                              context, AppRoutes.shared.paymentMethodsViewer,
                              arguments: PaymentMethodsArgs(
                                showHushhCoins: false,
                                currency: sl<HomePageBloc>().currency,
                                amount: double.tryParse(text ?? "") ?? 0,
                                description: "Adding funds to Hushh wallet",
                                onPaymentDone: () async {
                                  sl<AgentCardWalletPageBloc>().updateCoins(
                                      double.parse(Utils().moneyToHushhCoins(
                                          text.isEmpty ? '0.00' : '$text.00')).toInt());
                                  setState(() {});
                                  Navigator.pop(context);
                                },
                                onPaymentFailed: () {
                                  ToastManager(Toast(
                                          title: 'Transaction failed!',
                                          notification: CustomNotification(
                                            title: 'Payment Failed!',
                                          ),
                                          type: ToastificationType.error))
                                      .show(context);
                                },
                              ));
                        },
                        sliderRotate: true,
                        submittedIcon:
                            const Icon(Icons.check, color: Colors.white),
                        enabled: text.isNotEmpty,
                        sliderButtonIcon: const Icon(Icons.keyboard_arrow_right,
                            color: Colors.blue),
                        textStyle:
                            context.bodyLarge?.copyWith(color: Colors.white),
                        outerColor: Colors.blue,
                        sliderButtonIconPadding: 10,
                      ),
                    ),
                  ),
                ),
              ),
              NumericKeyboard(
                onKeyboardTap: (value) {
                  text = text + value;
                  setState(() {});
                },
                textColor: Colors.black,
                leftButtonFn: () {
                  setState(() {
                    text = text.substring(0, text.length - 1);
                  });
                },
                leftIcon: const Icon(
                  Icons.backspace_outlined,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}
