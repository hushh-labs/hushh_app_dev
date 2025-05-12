import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/bloc/card_market_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/components/mail_auth_button.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toastification/toastification.dart';

class ReceiptRadarAuthBottomSheet extends StatefulWidget {
  const ReceiptRadarAuthBottomSheet({super.key});

  @override
  State<ReceiptRadarAuthBottomSheet> createState() => _ReceiptRadarAuthBottomSheetState();
}

class _ReceiptRadarAuthBottomSheetState extends State<ReceiptRadarAuthBottomSheet> {
  @override
  void initState() {
    sl<CardMarketBloc>().add(FetchCardMarketEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      height: 45.h,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Link Your Account',
                style: textTheme.headlineLarge,
              ),
            ),
          ),
          const Expanded(
            flex: 4,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MailAuthButton(
                    provider: EmailProvider.google,
                  ),
                  SizedBox(height: 16),
                  MailAuthButton(
                    provider: EmailProvider.outlook,
                  ),
                  SizedBox(height: 16),
                  MailAuthButton(
                    provider: EmailProvider.yahoo,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: RichText(
                text: TextSpan(
                  text: 'Not sure which account to use? ',
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Tap here',
                      style: const TextStyle(
                        color: Color(0xFFA342FF),
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          ToastManager(Toast(
                                  title: "Coming Soon",
                                  type: ToastificationType.info))
                              .show(context);
                        },
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
